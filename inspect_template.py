from docx import Document
import os
path = os.path.join('docs','2. Mau tai lieu.docx')
doc = Document(path)
for i,p in enumerate(doc.paragraphs):
    text = p.text.strip()
    if text:
        print(i, repr(text))
