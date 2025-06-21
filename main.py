from fastapi import FastAPI, HTTPException
from url_to_llm_text.get_html_text import get_page_source
from url_to_llm_text.get_llm_input_text import get_processed_text

app = FastAPI()

@app.get("/process")
async def process(url: str, max_chars: int | None = None):
    try:
        page_source = await get_page_source(url)
        text = await get_processed_text(page_source, url)
        if max_chars:
            text = text[:max_chars]
        return {"ok": True, "text": text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
