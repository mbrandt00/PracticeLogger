-- Drop existing foreign key constraints
ALTER TABLE public.movements
  DROP CONSTRAINT IF EXISTS movements_piece_id_fkey;

ALTER TABLE public.practice_sessions
  DROP CONSTRAINT IF EXISTS practice_sessions_piece_id_fkey;


-- Add constraints back with ON DELETE CASCADE
ALTER TABLE public.movements
  ADD CONSTRAINT movements_piece_id_fkey
  FOREIGN KEY (piece_id) REFERENCES public.pieces(id) ON DELETE CASCADE;

ALTER TABLE public.practice_sessions
  ADD CONSTRAINT practice_sessions_piece_id_fkey
  FOREIGN KEY (piece_id) REFERENCES public.pieces(id) ON DELETE CASCADE;

CREATE POLICY auth_delete_pieces ON pieces FOR DELETE TO authenticated USING (user_id = auth.uid());

