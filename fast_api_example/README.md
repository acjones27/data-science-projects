# FastAPI example

Following the docs [here](https://fastapi.tiangolo.com/tutorial/)

## How to run

Install fastAPI and uvicorn

```python
pip install "fastapi[all]"
```

Make sure you're in the right directory *(i.e. this one) and start the server with uvicorn
```bash
cd fast_api_example/
uvicorn main:app --reload
```

Docs can be found at the [Swagger page](http://127.0.0.1:8000/docs)

## Example app

```python
# Import FastAPI
from fastapi import FastAPI

# Create FastAPI instance, the main point of interaction to the API
# This is the 'app' referred to by 'uvicorn main:app' and in the decorators
app = FastAPI()

# the function right below handles requests to "/" using a "get" operation
# async: https://fastapi.tiangolo.com/async/#in-a-hurry
@app.get("/")
async def root():
    # Return the content (can be dict, list, str, int, Pydantic model etc)
    return {"message": "Hello World"}
```
