require 'array.rb'
require 'rspec'
require 'spec_helper.rb'

describe Array do

  let(:a) { Array.new }

  describe "#uniq" do
    it "responds to #uniq" do
      a.should respond_to(:uniq)
    end

    it "removes duplicates" do
      a = [1, 2, 1, 3, 3]
      expect(a.uniq).to eq([1, 2, 3])
    end
  end

  describe "#two_sum" do
    it "responds to #two_sum" do
      a.should respond_to(:two_sum)
    end

    it "returns 2D array of indices that add to zero" do
      a = [-1, 0, 2, -2, 1]
      expect(a.two_sum).to eq([[0, 4], [2, 3]])
    end

    it "should return ordered arrays" do
      a = [0, 2, -2, 1, -1]
      expect(a.two_sum).to eq([[1, 2], [3, 4]])
    end
  end

  describe "#my_transpose" do

    let(:a) { [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8]
      ]}

      it "responds to #my_transpose" do
        a.should respond_to(:my_transpose)
      end

      it "should return the same number of rows as original" do
        expect(a.my_transpose.length).to eq(3)
      end

      it "each row should still have 3 items" do
        expect(a.my_transpose.all? { |row| row.count == 3}).to eq(true)
      end

      it "should switch array columns and row" do
        expect(a.my_transpose).to eq ([
          [0, 3, 6],
          [1, 4, 7],
          [2, 5, 8]
          ])
        end

      end

      describe '#best_days' do
        let(:prices) { Array.new }

        it "responds to #best_days" do
          prices.should respond_to(:best_days)
        end

        it "only sells in days after day of pucrhase" do
          prices = [10, 15, 7, 9]
          expect(prices.best_days).to eq([0,1])
        end

        it 'will not give bach the correct date when there are duplicates for max price' do
          prices = [20, 67, 2, 67]
          expect(prices.best_days).to eq([2,3])
        end

        it 'will return [] if no two days of profit are found' do
          prices = [15, 9, 7, 1]
          expect(prices.best_days).to eq([])
        end

      end
    end

    describe TowersofHanoi do

      let(:h) { TowersofHanoi.new }

      it "has three stacks" do
        expect(h.stacks.count).to eq(3)
      end

      it 'has 2 stacks that are empty arrays' do
        expect(h.stacks[1..-1]).to eq([[], []])
      end

      it 'always takes the top/smallest disc' do
        h.move(0,1)
        expect(h.stacks).to eq([[3, 2], [1], []])
      end

      it 'only allows discs to be moved unto empty stacks or on top of bigger discs' do
        h.move(0,1)
        h.move(0,1)
        expect(h.stacks).to eq([[3, 2], [1], []])
      end

      it 'returns false when game is not won' do
        expect(h.won?).to eq(false)
      end

      it 'returns won when all discs are on stack 3, and stack 1 and stack 2 are empty' do
        h.stacks = [[], [], [3, 2, 1]]
        expect(h.won?).to eq(true)
      end

    end

