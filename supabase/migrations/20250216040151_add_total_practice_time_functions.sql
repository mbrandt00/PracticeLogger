CREATE OR REPLACE FUNCTION update_practice_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- Update pieces stats
    UPDATE public.pieces
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE piece_id = pieces.id
        ),
        last_practiced = (
            SELECT GREATEST(
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE piece_id = pieces.id
                ), NULL),
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE movement_id IN (SELECT id FROM public.movements WHERE piece_id = pieces.id)
                ), NULL)
            )
        )
    WHERE id IN (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.piece_id 
            ELSE NEW.piece_id 
        END
    );

    -- Update movements stats
    UPDATE public.movements
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE movement_id = movements.id
        ),
        last_practiced = (
            SELECT GREATEST(
                MAX(end_time),
                MAX(start_time)
            )
            FROM public.practice_sessions 
            WHERE movement_id = movements.id
        )
    WHERE id IN (
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.movement_id 
            ELSE NEW.movement_id 
        END
    );
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


ALTER TABLE public.pieces 
ADD COLUMN total_practice_time integer,
ADD COLUMN last_practiced timestamp with time zone;
ALTER TABLE public.movements 
ADD COLUMN total_practice_time integer,
ADD COLUMN last_practiced timestamp with time zone;


CREATE TRIGGER practice_sessions_stats_trigger
AFTER INSERT OR UPDATE OR DELETE
ON public.practice_sessions
FOR EACH ROW EXECUTE FUNCTION update_practice_stats();

GRANT EXECUTE ON FUNCTION update_practice_stats() TO authenticated;

-- RLS policy for pieces/movements table to allow updates from the trigger
CREATE POLICY "Allow updates from trigger" ON public.pieces
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow updates from trigger" ON public.movements
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);
