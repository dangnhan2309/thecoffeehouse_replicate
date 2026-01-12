from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from database import Base, engine
from routers import (
    auth,
    product as product_router,
    order as order_router,
    favorite as favorite_router,
    category as category_router,
    banner,
    vourcher,
    explore,
    promotion,
    collection,
    store as store_router
)

Base.metadata.create_all(bind=engine)

app = FastAPI(title="The Coffee House API")

# =======================
# CORS – BẮT BUỘC CHO WEB
# =======================
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost",
        "http://localhost:63234",  # Flutter Web port
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =======================
# ROUTERS (SAU CORS)
# =======================
app.include_router(auth.router)
app.include_router(category_router.router)
app.include_router(product_router.router)
app.include_router(order_router.router)
app.include_router(favorite_router.router)
app.include_router(banner.router)
app.include_router(vourcher.router)
app.include_router(explore.router)
app.include_router(promotion.router)
app.include_router(collection.router)
app.include_router(store_router.router)
# =======================
# STATIC FILES
# =======================
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
def root():
    return {"message": "The Coffee House API is running!"}
