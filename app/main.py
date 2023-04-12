import streamlit as st

# ページ設定
page_title = "Sample"
page_icon = "👨‍💻"
st.set_page_config(page_title=page_title, page_icon=page_icon)

# ページ内容
st.write(f"# {page_icon} {page_title}")
st.write("docker×streamlitサンプル")
