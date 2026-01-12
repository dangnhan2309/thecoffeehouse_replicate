from fastapi import FastAPI
from database import Base, engine
from routers import auth, product as product_router, order as order_router, favorite as favorite_router, category as category_router,banner, explore, promotion, collection
from fastapi.staticfiles import StaticFiles


Base.metadata.create_all(bind=engine)

app = FastAPI(title="The Coffee House API")

app.include_router(auth.router)
app.include_router(category_router.router)
app.include_router(product_router.router)
app.include_router(order_router.router)
app.include_router(favorite_router.router)
app.include_router(banner.router)
app.include_router(explore.router)
app.include_router(promotion.router)
app.include_router(collection.router)

app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
def root():
    return {"message": "The Coffee House API is running!"}