#!/bin/bash

python3 -m venv env
source env/bin/activate
cd new-project
python -m pushtotalk --device-model-id roy-model --project-id lofty-ivy-192309