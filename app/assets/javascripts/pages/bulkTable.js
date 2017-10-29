(function (root, factory) {
  if (typeof module === 'object' && module.exports) {
    module.exports = factory(require('jQuery'), require('../common/utility'));
  } else {
    root.bulkTable = factory(root.jQuery, root.utility);
  }
}(this, function ($, util) {

  var self = {}; // returned at bottom of file

  // STATE MANAGEMENT
  var state = {};

  // TODO: parameterize these!
  var columns = [{
    label: 'Name',
    attr:  'name',
    input: 'text'
  },{
    label: 'Entity Type',
    attr:  'primary_ext',
    input: 'select'
  },{
    label: 'Description',
    attr:  'blurb',
    input: 'text'
  }];

  var ids = {
    uploadButton:  "bulk-add-upload-button",
    notifications: "bulk-add-notifications"
  };

  self.init = function(args){
    state = Object.assign(state, {
      // derrived
      rootId:         args.rootId,
      endpoint:       args.endpoint || "/",
      // deterministic
      canUpload:      true,
      notification:   "",
      entities:       { byId:    {},
                        rowIds:  [], // TODO: change to `order`
                        matches: {} }
      // When/if we wish to paramaterize row fields, we would here paramaterize:
      //   1. resource type (currently always entity)
      //   2. columns by resource type (currently stored as constant above)
    });
    self.render();
    detectUploadSupport();
  };

  // getters

  self.get = function(attr){
    return util.get(state, attr);
  };

  self.getIn = function(attrs){
    return util.getIn(state, attrs);
  };

  state.hasRows = function(){
    return !util.isEmpty(state.entities.rowIds);
  };

  state.getMatch = function(entity, matchId){
    return util.get(state.getMatches(entity), matchId);
  };

  state.getMatches = function(entity){
    return util.getIn(state, ['entities', 'matches', entity.id, 'byId']) || {};
  };

  state.getOrderedMatches = function(entity){
    return util.getIn(state, ['entities', 'matches', entity.id, 'order'])
      .map(function(matchId){ return state.getMatch(entity, matchId); });
  };

  state.hasMatches = function(entity){
    return !util.isEmpty(state.getMatches(entity));
  };

  // setters

  // Entity -> Entity
  state.addEntity = function(entity){
    state = util.setIn(
      util.setIn(state, ['entities', 'byId', entity.id],entity),
      ['entities', 'rowIds'],
      util.getIn(state, ['entities', 'rowIds']).concat(entity.id)
    );
    return entity;
  };

  // Entity -> Entity
  state.assignId = function(entity, idx){
    return Object.assign(entity, { id: "newEntity" + idx });
  };

  // [Entity] -> Promise[Void]
  state.matchEntities = function(entities){
    return Promise.all(entities.map(state.matchEntity));
  };

  // Entity -> Promise[Void]
  state.matchEntity = function(entity){
    return api.searchEntity(entity.name)
      .then(state.addMatches(entity));
  };

  state.addMatches = function(entity){
    return function(matches){
      state = util.setIn(
        state,
        ['entities', 'matches', entity.id],
        {
          byId:     util.normalize(matches),
          order:    matches.map(function(match){ return match.id; }),
          selected: null
        }
      );
    };
  };

  state.disableUpload = function(){
    state.canUpload = false;
  };

  state.setNotification = function(msg){
    state.notification = msg;
  };

  // ENVIRONMENT DETECTION

  function detectUploadSupport(){
    if (!util.browserCanOpenFiles()) {
      state.disableUpload();
      state.setNotification('Your browser does not support uploading files to this page.');
      self.render();
    }
  }

  // FILE HANDLING

  function handleUploadThen(processFile, caller){
    if (self.hasFile(caller)) {
      var reader = new FileReader();
      reader.onloadend = function() {  // triggered when file is finished being read
        reader.result ? processFile(reader.result): console.error('Error reading csv');
      };
      reader.readAsText(self.getFile(caller)); // start reading (will trigger `onloadend` when done)
    }
  };

  // String -> Promise[Void]
  function ingestEntities (csv){
    const entities = Papa
          .parse(csv, { header: true, skipEmptyLines: true})
          .data
          .map(state.assignId)
          .map(state.addEntity);
    return state.matchEntities(entities)
      .then(state.disableUpload)
      .then(self.render);
  };

  // expose below 2 functions for testing  seams
  // (cannot mutate caller.files for security reasons)
  
  self.hasFile = function(caller){
    return Boolean(caller.files[0]);
  };

  self.getFile = function(caller){
    return caller.files[0];
  };

  // RENDERING

  self.render = function(){
    $('#' + state.rootId).empty();
    $('#' + state.rootId)
      .append(notifications())
      .append(state.canUpload ? uploadContainer() : null)
      .append(state.hasRows()? table() : null);
  };

  function notifications(){
    return $('<div>', {
      id: ids.notifications,
      text: state.notification
    });
  };

  function uploadContainer(){
    return $('<div>', {id: 'bulk-add-upload-container'})
      .append(uploadButton());
  }

  function uploadButton(){
    return $('<label>', {
      class: 'btn btn-primary btn-file',
      text: 'Upload CSV'
    }).append(
      $('<input>', {
        id:    ids.uploadButton,
        type:  "file",
        style: "display:none",
        change: function() { handleUploadThen(ingestEntities, this); }
      })
    );
  }

  function table(){
    return $('<table>', { id: 'bulk-add-table'})
      .append(thead())
      .append(tbody());
  };

  function thead(){
    return $('<thead>').append(
      $('<tr>').append(
        columns.map(function(c) {
          return $('<th>', {
            text: c.label
          });
        })
      )
    );
  }

  function tbody(){
    return $('<tbody>').append(
      state.entities.rowIds.map(function(id){
        var entity = util.get(state.entities.byId, id);
        return $('<tr>').append(
          columns.map(function(col, idx){
            return $('<td>', {
              text: util.get(entity, col.attr)
            }).append(
              maybeResolver(entity, col, idx)
            );
          })
        );
      })
    );
  }

  function maybeResolver(entity, col, idx) {
    return idx == 0 && state.hasMatches(entity) && resolver(entity);
  }

  function resolver(entity) {
    return $('<div>', {
      class:         'resolver-anchor',
      cursor:        'pointer',
      'data-toggle': 'popover',
      click:         activatePicker
    })
      .append($('<div>', { class: 'alert-icon' }))
      .popover({
        html:     true,
        title:    'Similar entities already exist!',
        content:  resolverPopup(entity)
      });
  }

  function activatePicker(){
    // wait until popover is in DOM, then call `#selectpicker()` to show selectpicker
    // do i LIKE this API? HELL NO! i didn't make the JQuery madness. i just live in it.
    // -- @aguestuser (25-Oct-2017)
    setTimeout(
      function(){$(".resolver-selectpicker").selectpicker();},
      5
    );
  }

  function resolverPopup(entity) {
    return $('<div>', { class: 'resolver-popover' })
      .append(pickerContainer(entity))
      .append(createButton(entity));
  };

  function createButton(entity){
    return $('<div>', {
      class: "btn btn-danger resolver-create-btn",
      text:  "Create New Entity",
      click: function(){ handleResolverCreate(entity); }
    });
  }

  function pickerContainer(entity){
    return $('<div>', { class: 'resolver-picker-container' })
      .append(picker(entity))
      .append(pickerResultContainer())
      .append(pickerButton());
  }

  function picker(entity){
    return $('<select>', {
      class:              'selectpicker resolver-selectpicker',
      title:              'Pick an existing entity...',
      'data-live-search': true,
      on:                 {
        'changed.bs.select': function(){
          handleResolutionPick(entity, $(this).val());
        }
      }
    }).append(
      state.getOrderedMatches(entity).map(function(match){
        return $('<option>', {
          class: 'resolver-option',
          text:  match.name,
          value: match.id
        });
      })
    );
  }

  function pickerResultContainer(){
    return $('<div>', { class: 'resolver-picker-result-container'});
  }

  function pickerResult(entity){
    return $('<div>', {
      class: 'resolver-picker-result'
    })
      .append($('<a>', {
        class:  'goto-link-icon',
        href:   entity.url,
        target: '_blank'
      }))
      .append($('<span>', {
        text: entity.blurb
      }));
  }

  function pickerButton(){
    return $('<div>', {
      class: 'btn btn-primary resolver-picker-btn',
      text:  'Use Existing Entity'
    });
  };

  function handleResolverCreate(entity){
    console.log('Creating entity with name ', entity.name);
  }

  function handleResolutionPick(entity, matchId){
    $(".resolver-picker-result-container")
      .empty()
      .append(pickerResult(state.getMatch(entity, matchId)));
  }

  // MISC

  // expose ingestEntities as testing seam for post-upload logic
  // (we want to act as though the csv has already uploaded w/o having to mock file-level browser behavior)
  self.ingestEntities = ingestEntities;

  // RETURN
  return self;
}));
