class Unicorn::HttpServer
  def worker_loop(worker)
    ppid = master_pid
    init_worker_process(worker)
    nr = 0 # this becomes negative if we need to reopen logs
    l = LISTENERS.dup
    ready = l.dup

    # closing anything we IO.select on will raise EBADF
    trap(:USR1) { nr = -65536; SELF_PIPE[0].close rescue nil }
    trap(:QUIT) { worker = nil; LISTENERS.each { |s| s.close rescue nil }.clear }
    logger.info "worker=#{worker.nr} ready"

    begin
      nr < 0 and reopen_worker_logs(worker.nr)
      nr = 0
      worker.tick = Time.now.to_i
      while sock = ready.shift
        start_process = Time.now.to_i
        if client = sock.kgio_tryaccept
          process_client(client)
          nr += 1
          elapsed = (Time.now.to_i - start_process) * 1000
          $stdout.puts("measure=unicorn.process val=#{elapsed}")
          worker.tick = Time.now.to_i
        end
        break if nr < 0
      end

      # make the following bet: if we accepted clients this round,
      # we're probably reasonably busy, so avoid calling select()
      # and do a speculative non-blocking accept() on ready listeners
      # before we sleep again in select().
      unless nr == 0 # (nr < 0) => reopen logs (unlikely)
        ready = l.dup
        redo
      end

      ppid == Process.ppid or return

      # timeout used so we can detect parent death:
      worker.tick = Time.now.to_i
      ret = IO.select(l, nil, SELF_PIPE, @timeout) and ready = ret[0]
    rescue => e
      redo if nr < 0 && (Errno::EBADF === e || IOError === e) # reopen logs
      Unicorn.log_error(@logger, "listen loop error", e) if worker
    end while worker
  end
end