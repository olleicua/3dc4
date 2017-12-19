require 'deepsort'
require './lines'

describe Box do
  describe '#initialize' do
    subject { described_class.new(n, m, box) }

    context '3x3' do
      let(:n) { 2 }
      let(:m) { 3 }

      context 'valid input' do
        let(:box) { [[1, 2, 3], [3, 4, 5], [5, 6, 7]] }
        it { expect { subject }.not_to raise_error }
      end

      context 'incorrect size' do
        let(:box) { [[1, 2, 3], [3, 4, 5], [6]] }
        it { expect { subject }.to raise_error 'Invalid box: all dimentions must be of size m = 3' }
      end

      context 'insufficient nesting' do
        let(:box) { [[1, 2, 3], [3, 4, 5], 6] }
        it { expect { subject }.to raise_error 'Invalid box: must nest to specified value of n = 2' }
      end

      context 'too much nesting' do
        let(:box) { [[1, 2, 3], [3, 4, 5], [5, 6, [7, 8, 9]]] }
        it { expect { subject }.to raise_error 'Invalid box: nesting exceeds specified value of n = 2' }
      end
    end

    context '2x2x2' do
      let(:n) { 3 }
      let(:m) { 2 }

      context 'valid input' do
        let(:box) { [[[1, 2], [1, 2]], [[1, 2], [1, 2]]] }
        it { expect { subject }.not_to raise_error }
      end

      context 'incorrect size' do
        let(:box) { [[[1, 2], [1, 2]], [[1, 2], [1, 2]], [[1, 2], [1, 2]]] }
        it { expect { subject }.to raise_error 'Invalid box: all dimentions must be of size m = 2' }
      end

      context 'insufficient nesting' do
        let(:box) { [[[1, 2], [1, 2]], 1] }
        it { expect { subject }.to raise_error 'Invalid box: must nest to specified value of n = 3' }
      end

      context 'too much nesting' do
        let(:box) { [[[1, 2], [1, 2]], [[1, 2], [1, [2, 3]]]] }
        it { expect { subject }.to raise_error 'Invalid box: nesting exceeds specified value of n = 3' }
      end
    end

    context '1x1x1x1x1' do
      let(:n) { 5 }
      let(:m) { 1 }

      context 'valid input' do
        let(:box) { [[[[[5]]]]] }
        it { expect { subject }.not_to raise_error }
      end
    end
  end

  describe '#lines' do
    subject { described_class.new(n, m, box).lines.to_a.deep_sort }

    context '3x3' do
      let(:n) { 2 }
      let(:m) { 3 }
      let(:box) { [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

      it do
        is_expected.to eq [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
          [1, 4, 7],
          [3, 6, 9],
          [2, 5, 8],
          [1, 5, 9],
          [3, 5, 7]
        ].deep_sort
      end
    end

    context '2x2x2' do
      let(:n) { 3 }
      let(:m) { 2 }
      let(:box) { [[[1, 2], [3, 4]], [[5, 6], [7, 8]]] }

      it 'enumerates over 28 lines' do
        expect(subject.size).to eq 28
      end

      it 'enumerates of 56 values' do
        count = 0
        described_class.new(n, m, box).lines do |line|
          count += line.size
        end
        expect(count).to eq 56
      end
    end
  end
end
