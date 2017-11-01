describe('Bulk Table module', () => {

  const asyncDelay = .1; // millis to wait for search, csv upload, etc..

  // TODO: sure would be nice to import this from app code and have a single source of truth!
  const columns = [{
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

  const ids = {
    uploadButton:  "bulk-add-upload-button",
    notifications: "bulk-add-notifications"
  };

  const entities = {
    newEntity0: {
      id:          "newEntity0",
      name:        "Lew Basnight",
      primary_ext: "Person",
      blurb:       "Adjacent to the invisible"
    },
    newEntity1: {
      id:          "newEntity1",
      name:        "Chums Of Chance",
      primary_ext: "Org",
      blurb:       "Do not -- strictly speaking -- exist"
    }
  };

  // stub search api call w/ 1 successful, 1 failed result
  const searchEntityFake = query => {
    switch(query){
    case entities.newEntity0.name:
      return Promise.resolve(searchResultsFor(entities.newEntity0));
    default:
      return Promise.resolve([]);
    }
  };

  const searchResultsFor = entity => [0,1,2].map(n => {
    const ext = ["Org", "Person"][n % 2];
    return {
      id:          `${n}${entity.id.slice(-1)}`,
      name:        `${entity.name} dupe name ${n}`,
      blurb:       `dupe description ${n}`,
      primary_ext:  ext,
      url:         `/${ext.toLowerCase()}/${n}/${entity.name.replace(" ", "")}`
    };
  });

  const csvValid =
        "name,primary_ext,blurb\n" +
        `${entities.newEntity0.name},${entities.newEntity0.primary_ext},${entities.newEntity0.blurb}\n` +
        `${entities.newEntity1.name},${entities.newEntity1.primary_ext},${entities.newEntity1.blurb}\n`;

  const testDom ='<div id="test-dom"></div>';

  const defaultState = {
    rootId:   "test-dom",
    endpoint: "/lists/1/new_entities"
  };

  let searchEntityStub;
  
  beforeEach(() => {
    searchEntityStub = spyOn(api, 'searchEntity').and.callFake(searchEntityFake);
    $('body').append(testDom);
  });
  afterEach(() => { $('#test-dom').remove(); });

  describe('initialization', () => {

    beforeAll(() => bulkTable.init(defaultState));

    it('stores a reference to its root node', () => {
      expect(bulkTable.get('rootId')).toEqual('test-dom');
    });

    it('stores an endpoint', () => {
      expect(bulkTable.get('endpoint')).toEqual("/lists/1/new_entities");
    });

    it('initializes an empty entities state tree', () =>{
      expect(bulkTable.get('entities')).toEqual({
        byId:    {},
        order:   [],
        matches: {},
        errors:  {}
      });
    });

    describe('detecting upload support', () => {

      let browserCanOpenFilesSpy;

      describe("when browser can open files", () => {

        beforeEach(() => {
          browserCanOpenFilesSpy = spyOn(utility, 'browserCanOpenFiles').and.returnValue(true);
          bulkTable.init(defaultState);
        });

        it('shows an upload button', () => {
          expect($(`#${ids.uploadButton}`)).toExist();
        });
      });

      describe('when browser cannot open files', () => {

        beforeEach(() => {
          browserCanOpenFilesSpy = spyOn(utility, 'browserCanOpenFiles').and.returnValue(false);
          bulkTable.init(defaultState);
        });

        it('hides the upload button', () => {
          expect($(`#${ids.uploadButton}`)).not.toExist();
        });

        it('displays an error message', () => {
          expect($(`#${ids.notifications}`).html()).toMatch('Your browser');
        });
      });
    });
  });

  describe('uploading csv', () => {

    let file, hasFileSpy, getFileSpy;

    const setup = (csv, done) => {
      file = new File([csv], "test.csv", {type: "text/csv"});
      hasFileSpy = spyOn(bulkTable, 'hasFile').and.returnValue(true);
      getFileSpy = spyOn(bulkTable, 'getFile').and.returnValue(file);
      bulkTable.init(defaultState);
      $(`#${ids.uploadButton}`).change();
      setTimeout(done, asyncDelay); // wait for file to upload
    };


    describe("with well-formed csv", () => {

      beforeEach(done => setup(csvValid, done));

      it('stores entity data', () => {
        expect(bulkTable.getIn(['entities', 'byId'])).toEqual({
          newEntity0: entities['newEntity0'],
          newEntity1: entities['newEntity1']
        });
      });

      it('stores row ordering', () => {
        expect(bulkTable.getIn(['entities', 'order'])).toEqual(Object.keys(entities));
      });

      it('hides upload button', () => {
        expect($(`#${ids.uploadButton}`)).not.toExist();
      });
    });

    describe('with invalid header fields', () => {

      const csvInvalidHeaders = "foo,bar\nbaz,bam\n";
      beforeEach(done => setup(csvInvalidHeaders, done));

      it('does not store csv data', () => {
        expect(bulkTable.getIn(['entities', 'byId'])).toEqual({});
      });

      it('displays an error message', () => {
        expect($("#bulk-add-notifications")).toContainText("Invalid headers");
      });

      it('still shows upload button', () => {
        expect($(`#${ids.uploadButton}`)).toExist();
      });
    });

    describe('with incorrectly formatted csv', () => {

      const csvInvalidShape = "name,primary_ext,blurb\nfoo,bar\n";
      beforeEach(done => setup(csvInvalidShape, done));

      it('does not store csv data', () => {
        expect(bulkTable.getIn(['entities', 'byId'])).toEqual({});
      });

      it('displays an error message', () => {
        var notification = $("#bulk-add-notifications").text();
        expect($("#bulk-add-notifications")).toContainText("CSV format error");
      });

      it('still shows upload button', () => {
        expect($(`#${ids.uploadButton}`)).toExist();
      });
    });

    describe('re-submitting valid csv after an invalid upload', () => {

      beforeEach(done => {
        setup("foobar", () => null);
        getFileSpy.and.returnValue(new File([csvValid], "_.csv", { type: "text/csv"} ));
        $(`#${ids.uploadButton}`).change();
        setTimeout(done, asyncDelay);
      });

      it('clears the error message', () => {
        expect($("bulk-add-notifications")).not.toExist();
      });

      it('hides the upload button', () => {
        expect($(`#${ids.uploadButton}`)).not.toExist();
      });
    });
  });

  describe('table', () => {

    let firstRow, secondRow;
    const findFirstRow = () => $("#bulk-add-table tbody tr:nth-child(1)");

    beforeEach(done => {
      bulkTable.init(defaultState);
      bulkTable.ingestEntities(csvValid);
      setTimeout(() => {
        firstRow = findFirstRow();
        secondRow = $("#bulk-add-table tbody tr:nth-child(2)");
        done();
      }, asyncDelay); // wait for mock search results to return
    });

    it('exists', () => {
      expect($('#test-dom table#bulk-add-table')).toExist();
    });

    it('has columns labeling entity fields', () => {
      const thTags = $('#bulk-add-table thead tr th').toArray();
      expect(thTags).toHaveLength(3);
      thTags.forEach((th, idx) => expect(th).toHaveText(columns[idx].label));
    });

    it('has rows showing values of entity fields', () => {
      const rows = $('#bulk-add-table tbody tr').toArray();
      expect(rows).toHaveLength(2);
      rows.forEach((row, idx) => {
        expect(row.textContent).toEqual( // row.textContent concatenates all cell text with no spaces
          columns.map(col => entities[`newEntity${idx}`][col.attr] ).join("")
        );
      });
    });

    describe('entity resolution', () => {

      describe('search', () => {

        it('searches littlesis for entities with same name as user submissions', () => {
          expect(searchEntityStub).toHaveBeenCalledWith(entities.newEntity0.name);
          expect(searchEntityStub).toHaveBeenCalledWith(entities.newEntity1.name);
        });

        it('stores list of search matches in memory', () => {
          expect(bulkTable.getIn(['entities', 'matches'])).toEqual({
            newEntity0: {
              byId:     utility.normalize(searchResultsFor(entities.newEntity0)),
              order:    ["00", '10', '20'],
              selected: null
            },
            newEntity1: {
              byId:     {},
              order:    [],
              selected: null
            }
          });
        });
      });

      describe('alert icons', () => {

        it('displays alert icons next to rows with search matches', () => {
          expect(firstRow.find(".resolver-anchor")).toExist();
        });

        it('does not display alert icons next to rows with no search matches', () => {

          expect(secondRow.find(".resolver-anchor")).not.toExist();
        });

        it('shows a popover when user clicks on alert icon', () => {
          firstRow.find('.resolver-anchor').trigger('click');
          expect(firstRow.find(".resolver-popover")).toExist();
        });
      });

      describe('popover', () => {

        let popover;
        const matches = searchResultsFor(entities.newEntity0);

        beforeEach(done => {
          firstRow.find(".resolver-anchor").trigger('click');
          popover = firstRow.find(".resolver-popover");
          setTimeout(done, asyncDelay);
        });

        it('has a title', () => {
          expect(firstRow.find(".popover-title")).toHaveText("Similar entities already exist!");
        });

        it('has a selectpicker with all matched entities', () => {
          matches.forEach(match => {
            expect(firstRow.find(".resolver-selectpicker")).toContainText(match.name);
          });
        });

        it('has a button to use an existing entity', () => {
          expect(popover.find(".resolver-picker-btn")).toContainText("Use Existing");
        });

        it('has a button to create a new entity', () => {
          expect(popover.find(".resolver-create-btn")).toContainText("Create New");
        });

        describe('when user selects an entity from the picker', () => {

          beforeEach(() => popover.find('select').val(matches[0].id).trigger('change'));

          it('records the selection in memory', () => {
            expect(bulkTable.getIn(['entities', 'matches', 'newEntity0', 'selected']))
              .toEqual(matches[0].id);
          });

          it('shows a section about user selection below the picker', () => {
            expect(popover.find(".resolver-picker-result-container")).toContainElement(".resolver-picker-result");
          });

          it('shows the matched entity blurb below the picker', () => {
            expect(popover.find(".resolver-picker-result")).toContainText(matches[0].blurb);
          });

          it('shows a glyph-link to the matched entity\'s profile below the picker', () => {
            expect(popover.find(".resolver-picker-result")).toContainElement('a.goto-link-icon');
            expect(popover.find("a.goto-link-icon")).toHaveAttr("href", matches[0].url);
          });
        });

        describe('when user chooses `Use Existing Entity`', () => {

          beforeEach(() => {
            popover.find('select').val(matches[0].id).trigger('change');
            popover.find('.resolver-picker-btn').trigger('click');
            firstRow = findFirstRow();
          });

          it('overwrites user-submitted entity with matched entity', () => {
            expect(bulkTable.getIn(['entities', 'byId', matches[0].id])).toEqual(matches[0]);
            expect(bulkTable.getIn(['entities', 'byId', 'newEntity0'])).not.toExist();
            expect(bulkTable.getIn(['entities', 'order', 0])).toEqual(matches[0].id);
          });

          it('stores no matches for the user-submitted entity', () => {
            expect(bulkTable.getIn(['entities', 'matches', 'newEntity0'])).not.toExist();
          });

          it('stores no matches for the already-matched entity', () => {
            expect(bulkTable.getIn(['entities', 'matches', matches[0].id])).not.toExist();
          });

          it('closes the popover', () => {
            expect(firstRow.find(".resolver-popover")).not.toExist();
          });

          it('removes the alert icon next to the row', () => {
            expect(firstRow.find(".resolver-anchor")).not.toExist();
          });
        });

        describe('when user chooses `Create New Entity`', () => {

          beforeEach(() => {
            popover.find('.resolver-create-btn').trigger('click');
            firstRow = findFirstRow();
          });

          it('deletes matches for the user-submitted entity', () => {
            expect(bulkTable.getIn(['entities', 'matches', 'newEntity0'])).toEqual(undefined);
          });

          it('closes the popover', () => {
            expect(firstRow.find(".resolver-popover")).not.toExist();
          });

          it('removes the alert icon next to the row', () => {
            expect(firstRow.find(".resolver-anchor")).not.toExist();
          });
        });
      });
    });

    describe('validation', () => {

      describe('rules', () => {

        const validEntity = {
          id:          'fakeId',
          name:        'ValidName',
          primary_ext: 'Org',
          blurb:       'valid blurb'
        };

        const baseEntitiesState = {
          byId:    {},
          order:   [],
          matches: {},
          errors:  {}
        };

        const stateOf = (entitySpec) => Object.assign({}, defaultState, {
          entities: Object.assign({}, baseEntitiesState, {
            byId: { fakeId: Object.assign({}, validEntity, entitySpec) }
          })
        });

        const errorsFor =(entitySpec) =>
              bulkTable
              .init(stateOf(entitySpec))
              .validate()
              .getIn([ 'entities', 'errors', 'fakeId']);

        it('handles a valid entity', () => {
          expect(errorsFor(validEntity)).toEqual({
            id:          [],
            name:        [],
            primary_ext: [],
            blurb:       []
          });
        });

        it('does not require a blurb', () => {
          expect(errorsFor({ blurb: '' })).toEqual({
            id:          [],
            name:        [],
            primary_ext: [],
            blurb:       []
          });
        });

        it('requires a name', () => {
          expect(errorsFor({ name: "" })).toEqual({
            id:          [],
            name:        ['is required', 'must be at least 2 characters long'],
            primary_ext: [],
            blurb:       []
          });
        });

        it('requires a name be at least two characters', () => {
          expect(errorsFor({ name: "x" })).toEqual({
            id:          [],
            name:        ['must be at least 2 characters long'],
            primary_ext: [],
            blurb:       []
          });
        });

        it('requires a primary extension', () => {
          expect(errorsFor({ primary_ext: "" })).toEqual({
            id:          [],
            name:        [],
            primary_ext: ['is required', 'must be either "Person" or "Org"'],
            blurb:       []
          });
        });

        it('requires a primary extension be either `Person` or `Org`', () => {
          expect(errorsFor({ primary_ext: "tommyknocker" })).toEqual({
            id:          [],
            name:        [],
            primary_ext: ['must be either "Person" or "Org"'],
            blurb:       []
          });
        });

        it('requires a person to have a first and last name', () => {
          expect(errorsFor({ primary_ext: "Person", name:"duende" })).toEqual({
            id:          [],
            name:        ['must have a first and last name'],
            primary_ext: [],
            blurb:       []
          });
        });
      });

      describe('showing error alerts', () => {
        it('alerts if a primary extension is not valid');
        it('alerts if a name is not valid');
      });

      describe('removing error alerts', () => {
        it('removes alert if primary extension error is fixed');
        it('removes alert if entity name error is fixed is fixed');
      });
    });

    describe('editing', () => {
      // TODO: can we descope this feature on first pass? (@aguestuser)
      it('has inputs specific to each field');
      it('updates the store when input values change');
    });

    describe('submitting', () => {
      // TODO: can we descope this feature on first pass? (@aguestuser)
      describe('there are invalid fields', () => {
        it('will not submit');
      });

      describe('there are no invalid fields', () => {
        it('submits a batch of entities to a list endpoint');

        describe('all submissions worked', () => {
          it('redirects to list members tab');
        });

        describe('some submissions failed', () => {
          it('deletes successful submissions from the store');
          it('marks failed submissions with error messages');
          it('renders table with only failed submissions');
        });
      });
    });
  });

  describe('table with no entities', () => {
    beforeEach(() => bulkTable.init(defaultState));

    it('does not exist', () =>{
      expect($('#test-dom table#bulk-add-table')).not.toExist();
    });
  });
});
