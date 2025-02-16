#!/bin/bash

# Reset the Supabase database
echo "Resetting Supabase database..."
supabase db reset

# Change to the data_ingest directory
echo "Changing to data_ingest directory..."
cd data_ingest || { echo "Error: data_ingest directory not found"; exit 1; }

# Activate the virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate || { echo "Error: Virtual environment activation failed"; exit 1; }

# Run the Python script
echo "Running database write script..."
python -m utils.write_to_pg

echo "Deactivating virtual environment..."
deactivate

echo "Database setup complete!"
