describe DatasetsController, type: :controller do
  it { is_expected.to route(:get, '/datasets').to(action: :index) }
  it { is_expected.to route(:get, '/datasets/nycc').to(action: :show, dataset: 'nycc') }
  it { is_expected.not_to route(:get, '/datasets/invalid').to(action: :show, dataset: 'invalid') }
end
