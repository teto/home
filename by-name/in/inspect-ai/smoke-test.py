from importlib.resources import files
from tempfile import TemporaryDirectory

from inspect_ai import Task, eval
from inspect_ai.dataset import Sample
from inspect_ai.log import read_eval_log
from inspect_ai.scorer import includes
from inspect_ai.solver import generate

with TemporaryDirectory() as log_dir:
    logs = eval(
        Task(
            dataset=[Sample(input="Return the default response.", target="Default output")],
            solver=generate(),
            scorer=includes(),
        ),
        model="mockllm/model",
        display="none",
        log_dir=log_dir,
    )
    assert len(logs) == 1
    log = read_eval_log(logs[0].location)
    assert log.status == "success", log.error
    assert log.results.completed_samples == 1
    assert log.results.scores[0].metrics["accuracy"].value == 1.0

viewer = files("inspect_ai").joinpath("_view", "dist")
assert viewer.joinpath("index.html").is_file()
assert any(viewer.joinpath("assets").iterdir())
