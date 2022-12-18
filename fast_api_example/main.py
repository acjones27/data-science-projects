# Imports
from fastapi import FastAPI
from enum import Enum
from typing import Union


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"

# Create FastAPI instance
app = FastAPI()

characters_db = {"Marge": "Simpson", "Dean": "Winchester", "Penelope": "Garcia"}

@app.get("/")
async def root():
    return {"message": "Hello! And Welcome. To my favourite murder! The minisode."}


@app.get("/users/me")
async def read_user_me():
    return {"user": "the current user"}


# http://127.0.0.1:8000/users/anna
@app.get("/users/{user_name}")
async def read_user(user_name: str):
    return {"user_name": user_name}


@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}

    return {"model_name": model_name, "message": "Have some residuals"}


# Path with a path e.g. /files//home/johndoe/myfile.txt
@app.get("/files/{file_path:path}")
async def read_file(file_path: str):
    return {"file_path": file_path}


# When you declare other function parameters that are not part of the path parameters, 
# they are automatically interpreted as "query" parameters.
# http://127.0.0.1:8000/characters/?skip=20&limit=2
@app.get("/characters/")
async def read_characters(skip: int = 0, limit: int = 10):
    return list(characters_db.items())[skip : skip + limit]


# You can declare optional query parameters, by setting their default to None
# short can be 1, True, true, on, yes (or any combination of uppercase)
# http://127.0.0.1:8000/characters/Dean?show=Supernatural
@app.get("/characters/{first_name}")
async def get_character(first_name: str, show: Union[str, None] = None, short: bool = False):
    character = {"character": first_name}
    if show:
        character.update({"show": show})
    if not short:
        character.update(
            {"description": f"The character {first_name} {characters_db.get(first_name, 'Unknown')}"}
        )
    return character