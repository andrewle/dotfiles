$(document).on('keydown', 'form.story *, form.story textarea', function(e) {
  if(e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
    $(this).parents('form').find('button.save').click();
  }
});

function fireEvent(element, event) {
  var evt = document.createEvent("HTMLEvents");
  evt.initEvent(event, true, true ); // event type,bubbling,cancelable
  element.dispatchEvent(evt);
}

var Story = {
  current: function () {
    return $('.aleSelected:first');
  },

  first: function () {
    var panel = Panel.current();
    return $('.items_container .story:first', panel);
  },

  select: function (story) {
    $('.aleSelected').removeClass('aleSelected');
    story.addClass('aleSelected');
    window.aleSelectedId = story.data('cid');
  },

  selectCid: function (cid) {
    var story = $('.story[data-cid=' + cid + ']', Panel.current());
    if (story === undefined) { return; }
    Story.select(story);
  },

  reapplySelection: function () {
    if (Story.current().length !== 0) { return; }
    Story.selectCid(window.aleSelectedId);
  }
};

var Panel = {
  current: function () {
    return $('.panel.aleCurrentPanel:first');
  },

  activate: function (panelName) {
    var panel = $('.panel.' + panelName);
    if (panel.hasClass('visible')) {
      Panel.select(panel);
      return true;
    } else {
      return false;
    }
  },

  select: function (panel) {
    $('.aleCurrentPanel').removeClass('aleCurrentPanel');
    panel.addClass('aleCurrentPanel');
  }
};

$(document).on('keyup', function (e) {
  if (!e.shiftKey) { return; }

  // Icebox
  if (e.keyCode == 73) {
    if (!Panel.activate('icebox')) { return; }
    Story.select(Story.first());
  }

  // Backlog
  if (e.keyCode == 66) {
    if (!Panel.activate('backlog')) { return; }
    Story.select(Story.first());
  }

  // Current
  if (e.keyCode == 67) {
    if (!Panel.activate('current')) { return; }
    Story.select(Story.first());
  }
});

$(document).on('keydown', function (e) {
  var panel = Panel.current(),
      keyCodes = [74, 13, 75, 88];
  if (panel.length === 0 && (keyCodes.indexOf(e.keyCode) == -1)) { return; }

  var currentStory = Story.current(),
      currentStoryId = currentStory.data('cid'),
      storyIds = $.map($('.story', panel), function (item) { return $(item).data('cid'); }),
      currentPos = $.inArray(currentStoryId, storyIds);

  if (currentStory.length === 0 || storyIds.length === 0) { return; }

  // Keypress J
  if (e.keyCode == 74) {
    var nextStoryId = storyIds[currentPos + 1];
    if (nextStoryId === undefined) { return; }
    Story.select($('.story[data-cid=' + nextStoryId + ']', panel));
  }

  // Keypress K
  if (e.keyCode == 75) {
    var prevStoryId = storyIds[currentPos - 1];
    if (prevStoryId === undefined) { return; }
    Story.select($('.story[data-cid=' + prevStoryId + ']', panel));
  }

  // Keypress X
  if (e.keyCode == 88) {
    var selector = $('.selector', currentStory);
    fireEvent(selector.get(0), 'click');
  }

  // Enter
  if (e.keyCode == 13) {
    var expander = $('.expander', currentStory);
    fireEvent(expander.get(0), 'click');
    return false;
  }
});

setInterval(function () {
  Story.reapplySelection();
}, 500);

$('body').append([
  "<style>",
  ".aleCurrentPanel .panel_header { background-color: #404040!important }",
  ".aleSelected .preview { background-color: #F8DA90!important }",
  "</style>"
].join(''));
