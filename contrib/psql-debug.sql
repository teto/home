; to debug db status
select blocked_locks.pid as blocked_pid,
         blocked_locks.granted,
         blocked_activity.usename as blocked_user,
         blocked_activity.client_addr as blocked_addr,
         blocked_activity.xact_start as blocked_xact_start,
         blocked_activity.state_change as blocked_state_change,
         blocking_locks.pid as blocking_pid,
         blocking_activity.usename as blocking_user,
         blocking_activity.client_addr as blocking_addr,
         blocking_activity.xact_start as blocking_xact_start,
         blocking_activity.state_change as blocking_state_change,
         blocked_activity.query as blocked_statement,
         blocking_activity.query as current_statement_in_blocking_process
   from pg_catalog.pg_locks blocked_locks
    join pg_catalog.pg_stat_activity blocked_activity on blocked_activity.pid = blocked_locks.pid
    join pg_catalog.pg_locks blocking_locks 
        on blocking_locks.locktype = blocked_locks.locktype
        and blocking_locks.database is not distinct from blocked_locks.database
        and blocking_locks.relation is not distinct from blocked_locks.relation
        and blocking_locks.page is not distinct from blocked_locks.page
        and blocking_locks.tuple is not distinct from blocked_locks.tuple
        and blocking_locks.virtualxid is not distinct from blocked_locks.virtualxid
        and blocking_locks.transactionid is not distinct from blocked_locks.transactionid
        and blocking_locks.classid is not distinct from blocked_locks.classid
        and blocking_locks.objid is not distinct from blocked_locks.objid
        and blocking_locks.objsubid is not distinct from blocked_locks.objsubid
        and blocking_locks.pid != blocked_locks.pid
    join pg_catalog.pg_stat_activity blocking_activity on blocking_activity.pid = blocking_locks.pid
   where not blocked_locks.granted;
