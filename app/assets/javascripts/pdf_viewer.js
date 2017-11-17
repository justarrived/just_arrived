var PDF_RESUME_DOM_ID = 'pdf-document';

function initPDFjs() {
  // Disable workers to avoid yet another cross-origin issue (workers need
  // the URL of the script to be loaded, and dynamically loading a cross-origin
  // script does not work).
  PDFJS.disableWorker = true;

  // The workerSrc property shall be specified.
  PDFJS.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';

  // Using DocumentInitParameters object to load binary data.
  var canvas = document.getElementById(PDF_RESUME_DOM_ID);

  if (!canvas) {
    return;
  }

  var url = canvas.attributes['data-url'].value;

  var loadingTask = PDFJS.getDocument(url);
  loadingTask.promise.then(function(pdf) {
    console.log('PDF loaded');

    // Fetch the first page
    var pageNumber = 1;
    pdf.getPage(pageNumber).then(function(page) {
      console.log('Page loaded');

      var scale = 1.5;
      var viewport = page.getViewport(scale);

      // Prepare canvas using PDF page dimensions
      var canvas = document.getElementById(PDF_RESUME_DOM_ID);
      var context = canvas.getContext('2d');
      canvas.height = viewport.height;
      canvas.width = viewport.width;

      // Render PDF page into canvas context
      var renderContext = {
        canvasContext: context,
        viewport: viewport
      };
      var renderTask = page.render(renderContext);
      renderTask.then(function () {
        console.log('Page rendered');
      });
    });
  }, function (reason) {
    // PDF loading error
    console.error(reason);
  });
}

$(document).ready(function() {
  initPDFjs();
});
