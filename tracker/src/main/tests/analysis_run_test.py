import pytest

from tracker.model.configuration import *
from tracker.model.workflow import *
from tracker.model.analysis import *
from tracker.model.analysis_run import *
import tracker.model.analysis_run
import uuid
import json
import os
import py.path
import datetime

def create_analysis_run():
    analysis_name = "My analysis"
    start_date = datetime.datetime.now()
    my_analysis = create_analysis(analysis_name, start_date, None)
    
    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, None)
    
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    my_analysis_run = tracker.model.analysis_run.create_analysis_run(my_analysis.analysis_id, config_id, my_workflow.workflow_id)
    
    return my_analysis_run

def test_create_analysis_run():
    
    my_analysis_run = create_analysis_run()
    
    assert my_analysis_run != None
    
    
def test_set_config_for_analysis_run():
    
    my_analysis_run = create_analysis_run()
    
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    
    my_analysis_run = set_configuration_for_analysis_run(my_analysis_run.analysis_run_id, my_config.config_id)
    
    assert my_analysis_run.config_id == config_id
      
@pytest.mark.parametrize("start_state", [
    (RUN_STATUS_READY),
    pytest.mark.xfail((RUN_STATUS_IN_PROGRESS)),
    (RUN_STATUS_COMPLETED),
    (RUN_STATUS_ERROR)
])  
def test_set_run_ready(start_state):
    
    my_analysis_run = create_analysis_run()
    my_analysis_run.run_status = start_state
    
    set_ready(my_analysis_run)
    
@pytest.mark.parametrize("start_state", [
    (RUN_STATUS_READY),
    pytest.mark.xfail((RUN_STATUS_IN_PROGRESS)),
    pytest.mark.xfail((RUN_STATUS_COMPLETED)),
    pytest.mark.xfail((RUN_STATUS_ERROR))
])  
def test_set_in_progress(start_state):
    
    my_analysis_run = create_analysis_run()
    my_analysis_run.run_status = start_state
    
    set_in_progress(my_analysis_run)
    
@pytest.mark.parametrize("start_state", [
    pytest.mark.xfail((RUN_STATUS_READY)),
    (RUN_STATUS_IN_PROGRESS),
    pytest.mark.xfail((RUN_STATUS_COMPLETED)),
    pytest.mark.xfail((RUN_STATUS_ERROR))
])  
def test_set_completed(start_state):
    
    my_analysis_run = create_analysis_run()
    my_analysis_run.run_status = start_state
    
    set_completed(my_analysis_run)
    
@pytest.mark.parametrize("start_state", [
    (RUN_STATUS_READY),
    (RUN_STATUS_IN_PROGRESS),
    (RUN_STATUS_COMPLETED),
    (RUN_STATUS_ERROR)
])  
def test_set_error(start_state):
    
    my_analysis_run = create_analysis_run()
    my_analysis_run.run_status = start_state
    
    set_error(my_analysis_run)