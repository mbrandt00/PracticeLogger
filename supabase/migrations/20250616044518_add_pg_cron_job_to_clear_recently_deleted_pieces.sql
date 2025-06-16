CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT cron.schedule(
  'daily_delete_soft_deleted_practice_sessions',
  '0 0 * * *',  -- every day at midnight UTC
  $$DELETE FROM practice_sessions
    WHERE deleted_at IS NOT NULL
    AND deleted_at <= now() - interval '30 days'$$
);
