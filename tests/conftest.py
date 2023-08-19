import pytest
from flaskapp import app


@pytest.fixture(scope='session')
def client():
    return app.test_client()
