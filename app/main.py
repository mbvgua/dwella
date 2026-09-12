from fastapi import FastAPI

app = FastAPI(
    title="dwella",
    description="a comprehensive digital platform designed to bridge communication and management gaps for rental properties",
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/license/mit",
    },
)


@app.get("/")
def home():
    return "hello world"
