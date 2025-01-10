/** Up Migration **/
create table if not exists imslp.opus_systems (
    id serial primary key,
    name varchar(50) not null,
    description text,
    composer_id integer references public.composers(id),
    created_at timestamptz default current_timestamp,
    unique(name, composer_id)
);

insert into imslp.opus_systems (name, description) values
    ('BWV', 'Bach-Werke-Verzeichnis (Bach Works Catalogue)'),
    ('Op.', 'Opus numbering'),
    ('K.', 'Köchel catalogue (Mozart works)'),
    ('D', 'Deutsch catalogue (Schubert works)'),
    ('RV', 'Ryom-Verzeichnis (Vivaldi works)')
on conflict do nothing;

/** Down Migration **/
drop table if exists imslp.opus_systems;
