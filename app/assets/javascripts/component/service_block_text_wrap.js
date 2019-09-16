

// if a service block has long text,
// a class needs to be applied to it to adjust the
// padding of the container so the text is properly centered
function test_for_service_block_text_wrap(containers){
  console.log('called!')
  if (containers.length > 0){
    console.log('- has ' + containers.length + ' containers')
    var text, weight, size, family, width, num_lines;
    for(var i=0; i<containers.length;i++){
      console.log(i)
      text = $(containers[i]).text().trim()
      weight = $(containers[i]).css('font-weight')
      size = $(containers[i]).css('font-size')
      family = $(containers[i]).css('font-family')
      width = Math.floor($(containers[i]).width())
      num_lines = Math.floor(getTextWidth(text, [weight, size, family].join(' ')) / width) + 1
      console.log('- text = ' + text)
      console.log('- font = ' + [weight, size, family].join(' '))
      console.log('- container width = ' + width)
      console.log('- text width = ' + getTextWidth(text, [weight, size, family].join(' ')))
      console.log('- num lines = ' + num_lines)

      // clear all existing classes
      $(containers[i]).removeClass('two-lines-text');
      $(containers[i]).removeClass('three-lines-text');

      if (num_lines === 2){
        // found text that is wrapping onto 2 lines - apply css class to this container
        console.log('>>> long text, applying class!')
        $(containers[i]).addClass('two-lines-text');
      }else if (num_lines === 3){
        // found text that is wrapping onto 3 lines - apply css class to this container
        console.log('>>> long text, applying class!')
        $(containers[i]).addClass('three-lines-text');
      }

    }
  }
}

// taken from: https://stackoverflow.com/a/21015393
/**
 * Uses canvas.measureText to compute and return the width of the given text of given font in pixels.
 *
 * @param {String} text The text to be rendered.
 * @param {String} font The css font descriptor that text is to be rendered with (e.g. "bold 14px verdana").
 *
 * @see https://stackoverflow.com/questions/118241/calculate-text-width-with-javascript/21015393#21015393
 */
var canvas;
function getTextWidth(text, font) {
  canvas = getTextWidth.canvas_text_width || (getTextWidth.canvas = document.createElement("canvas"));
  var context = canvas.getContext("2d");
  context.font = font;
  var metrics = context.measureText(text);
  return metrics.width;
}
