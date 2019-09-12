function setUpViewer(viewJson) {
  var viewer = $('.wysiwyg-viewer');
  if (viewer) {
    var quill = new Quill('.wysiwyg-viewer', {
      readOnly: true,
      modules: {
        toolbar: false
      },
      theme: 'snow'
    });

    var editorContent = viewJson.replace(/&quot;/g,'"').replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t");
    var editorJson = JSON.parse(editorContent)
    quill.setContents(editorJson, 'api');
  }
}

function setUpEditor(viewJson) {
  var quill = new Quill('.wysiwyg-editor', {
    modules: {
      toolbar: [
        ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
        ['blockquote', 'code-block'],
        ['image'],
      
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
        [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
        [{ 'align': [] }],
      
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
      
        [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
        [{ 'font': [] }],
    
      ]
    },
    theme: 'snow'
  });

  var editorContent = viewJson.replace(/&quot;/g,'"').replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t");
  var editorJson = JSON.parse(editorContent)
  quill.setContents(editorJson, 'api');
  
  return quill;
}

