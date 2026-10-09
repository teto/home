from importlib.resources import files
import hashlib
from tempfile import TemporaryDirectory
from unittest.mock import patch

import anyio

from inspect_ai import Task, eval
from inspect_ai.dataset import Sample
from inspect_ai.log import read_eval_log
from inspect_ai.scorer import includes
from inspect_ai.solver import generate
from inspect_ai.tool._sandbox_tools_utils.sandbox import (
    _get_executable_name,
    _open_executable_for_arch,
)


async def check_sandbox_tools():
    sums = files("inspect_ai").joinpath("tool", "_sandbox_tools_utils", "SHA256SUMS")
    digests = dict(line.split()[::-1] for line in sums.read_text().splitlines())
    with (
        patch(
            "inspect_ai.tool._sandbox_tools_utils.sandbox._download_from_s3",
            side_effect=AssertionError("Sandbox tools must be bundled"),
        ),
        patch(
            "inspect_ai.tool._sandbox_tools_utils.sandbox._build_it",
            side_effect=AssertionError("Sandbox tools must not require a runtime build"),
        ),
    ):
        for arch in ("amd64", "arm64"):
            for musl in (False, True):
                async with _open_executable_for_arch(arch, musl) as (name, binary):
                    assert name == _get_executable_name(arch, False, musl)
                    assert hashlib.file_digest(binary, "sha256").hexdigest() == digests[name]


anyio.run(check_sandbox_tools)

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
