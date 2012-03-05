Editor = {
  start: function(options) {
    var createEditor = function() {
      $('#version_content').wysiwyg({
        css: options.css,
        controls: {
          bold: { visible: true },
          italic: { visible: true },
          insertUnorderedList: { visible: true }
        },
        events: {
          keyup: unpublish
        },
        iFrameClass: 'editorFrame',
        rmUnusedControls: true
      });
      $('.editorFrame').attr('id', 'editor');
      $('.wysiwyg .toolbar .insertUnorderedList').text('list');

      if ($('#version_content').val().indexOf('<p>') == -1) {
        $('#version_content').data('wysiwyg').events.bind('getContent', function(text) {
          return text.
            replace(/<\/p><p>/g, '<br />').
            replace(/^<p>/, '').
            replace(/<\/p>$/, '');
        });
      }
    };

    var preferHtml = function() {
      $('#version_content').wysiwyg('destroy');
      $('#edit_html').hide();
      $('#edit_simple').show();
      $('#prefer_html').val('true');
    };

    var unpublish = function() {
      $('.explanation').html(options.draftExplanation);
      $('.published').remove();
      $('#version_published_input').show();
      $('#version_published_false').attr('checked', 'checked');
    };

    createEditor();

    $('#version_content').keyup(unpublish);
    $('#version_published_false').click(unpublish);

    $('#version_published_true').click(function () {
      $('.explanation').html(options.publishedExplanation);
    });

    $('.show_published_version').live('click', function () {
      $('.published_version').slideToggle();
      return false;
    });

    if(options.preferHtml)
      preferHtml();

    $('#edit_html').click(function(){
      preferHtml();
      return false;
    });

    $('#edit_simple').click(function(){
      createEditor();
      $('#edit_simple').hide();
      $('#edit_html').show();
      $('#prefer_html').val('false');
      return false;
    });
  }
};
