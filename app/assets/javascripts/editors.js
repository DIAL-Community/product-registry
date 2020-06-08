function setUpViewer(viewJson, editorId) {
  formSelector = '.wysiwyg-viewer'
  if (editorId) {
    formSelector = '#' + editorId
  }
  var viewer = $(formSelector);
  if (viewer) {
    var quill = new Quill(formSelector, {
      readOnly: true,
      modules: {
        toolbar: false
      },
      theme: 'snow'
    });
    
    if (!jQuery.isEmptyObject(viewJson)) {
      var editorJson = viewJson;
      if (typeof viewJson === 'string' || viewJson instanceof String) {
        editorJson = JSON.parse(viewJson);
      }
      quill.setContents(editorJson, 'api');
    }
  }
}


function setViewerForElement(elementId, viewJson) {
  var container = document.getElementById(elementId);
  if (container) {
    var quill = new Quill(container, {
      readOnly: true,
      modules: {
        toolbar: false
      },
      theme: 'snow'
    });

    if (!jQuery.isEmptyObject(viewJson)) {
      var editorJson = viewJson;
      if (typeof viewJson === 'string' || viewJson instanceof String) {
        editorJson = JSON.parse(viewJson);
      }
      quill.setContents(editorJson, 'api');
    }
  }
}

function setUpEditor(viewJson, placeholderText, editorId) {
  formSelector = '.wysiwyg-editor'
  if (editorId) {
    formSelector = '#' + editorId
  }
  var quill = new Quill(formSelector, {
    modules: {
      imageResize: {
        toolbarStyles: {
          display: 'none'
        }
      },
      toolbar: [
        ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
        ['blockquote', 'code-block'],
        ['link', 'image'],
      
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
        [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
        [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent
        [{ 'align': [] }],
      
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
      
        [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
        [{ 'font': [] }],
      ]
    },
    placeholder: placeholderText,
    theme: 'snow'
  });

  if (!jQuery.isEmptyObject(viewJson)) {
    var editorJson = viewJson;
    if (typeof viewJson === 'string' || viewJson instanceof String) {
      editorJson = JSON.parse(viewJson);
    }
    quill.setContents(editorJson, 'api');
  }
  
  return quill;
}

