CREATE TYPE catalogue_type AS ENUM (
    'op', 'k', 'bwv', 'd', 'l', 'woo', 'b', 'wq', 'cpeb', 'vb', 'dd', 
    'h', 'wd', 'wab', 't', 'fmw', 'eg', 's', 'th', 'twv', 'rv', 
    'hwv', 'hob', 'cff', 'wwv', 'trv', 'sz', 'fp', 'j', 'ms', 'jb', 
    'gb', 'opp', 'do', 'bv', 'jw', 'cnw', 'lwv', 'tn', 'kk', 'anh', 
    'cd', 'mwv', 'm', 'kochs', 'js', 'r', 'f', 'fwv', 'wo',
    -- Mendelssohn MWV categories
    'mwva', 'mwvb', 'mwvc', 'mwvd', 'mwve', 'mwvf', 'mwvg', 'mwvh',
    'mwvj', 'mwvk', 'mwvl', 'mwvm', 'mwvn', 'mwvo', 'mwvp', 'mwvq',
    'mwvr', 'mwvs', 'mwvt', 'mwvu', 'mwvv', 'mwvw', 'mwvx', 'mwvy', 'mwvz',
    -- Mozart catalog variations
    'k2', 'k3', 'k6', 'k9', 'k046', 'k030', 'k008',
    -- Additional catalog types
    'beckmann', 'emans', 'engk', 'howv', 'durg',
    'gwv', 'jlb', 'sc', 'dlr', 'heilb', 'variant', 'tvwv', 'sno', 'angsa',
    'hess', 'wn', 'arco', 'ath', 'opus', 'rism', 'fs', 'add', 'fawv',
    'whie', 'eisen'
);

ALTER TABLE pieces
ADD COLUMN catalogue_type catalogue_type,
ADD COLUMN catalogue_number INT;
