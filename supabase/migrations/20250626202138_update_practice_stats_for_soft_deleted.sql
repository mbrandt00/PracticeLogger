CREATE OR REPLACE FUNCTION update_practice_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.pieces
    SET 
        total_practice_time = (
            SELECT COALESCE(SUM(duration_seconds), 0) 
            FROM public.practice_sessions 
            WHERE piece_id = pieces.id AND deleted_at IS NULL
        ),
        last_practiced = (
            SELECT GREATEST(
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE piece_id = pieces.id AND deleted_at IS NULL
                ), NULL),
                COALESCE((
                    SELECT GREATEST(
                        MAX(end_time),
                        MAX(start_time)
                    ) 
                    FROM public.practice_sessions 
                    WHERE movement_id IN (
                        SELECT id FROM public.movements WHERE piece_id = pieces.id
                    ) AND deleted_at IS NULL
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
            WHERE movement_id = movements.id AND deleted_at IS NULL
        ),
        last_practiced = (
            SELECT GREATEST(
                MAX(end_time),
                MAX(start_time)
            )
            FROM public.practice_sessions 
            WHERE movement_id = movements.id AND deleted_at IS NULL
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
