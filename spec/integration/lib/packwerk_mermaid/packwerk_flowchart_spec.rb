# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PackwerkMermaid::PackwerkFlowchart do
  let(:instance) { described_class.new(config) }
  let(:config) do
    Struct.new(
      :packwerk_directory,
      :packwerk_package_name_mapping,
      :packwerk_loader,
      :packwerk_package_name_callback,
      :packwerk_packages_hidden,
      :mermaid_title,
      :mermaid_text_type,
      :mermaid_shape_style
    ).new(
      'fake-dir',
      packwerk_package_name_mapping,
      Proc.new { |_dir| Struct.new(:packages).new(packs) },
      packwerk_package_name_callback,
      packwerk_packages_hidden,
      'Title',
      PackwerkMermaid::MermaidFlowchartBuilder::TEXT,
      PackwerkMermaid::MermaidFlowchartBuilder::RECTANGLE_ROUNDED,
    )
  end
  let(:packs) { [] }
  let(:packwerk_package_name_mapping) { {} }
  let(:packwerk_package_name_callback) { nil }
  let(:packwerk_packages_hidden) { [] }

  describe '#generate' do
    subject(:flowchart) { instance.generate }

    it 'returns the mermaid flowchart' do
      expect(flowchart).to eq(
        <<~MERMAID
          ---
          title: Title
          ---
          flowchart TD
        MERMAID
      )
    end

    context 'when there are multiple packs defined' do
      let(:packs) do
        [
          ['packs/pack0', double(name: 'packs/pack0', dependencies: ['packs/pack1'])],
          ['packs/pack1', double(name: 'packs/pack1', dependencies: ['packs/pack2', 'packs/pack3'])],
          ['packs/pack2', double(name: 'packs/pack2', dependencies: [])],
          ['packs/pack3', double(name: 'packs/pack3', dependencies: [])],
        ]
      end

      it 'returns the mermaid flowchart with the nodes' do
        expect(flowchart).to eq(
          <<~MERMAID
            ---
            title: Title
            ---
            flowchart TD
                0("packs/pack0") --> 1("packs/pack1");
                1 --> 2("packs/pack2");
                1 --> 3("packs/pack3");
          MERMAID
        )
      end
    end

    context 'when there are multiple packs with renaming rules' do
      let(:packs) do
        [
          ['packs/pack0', double(name: 'packs/pack0', dependencies: ['packs/pack1'])],
          ['packs/pack1', double(name: 'packs/pack1', dependencies: ['packs/pack2', 'packs/pack3'])],
          ['packs/pack2', double(name: 'packs/pack2', dependencies: [])],
          ['packs/pack3', double(name: 'packs/pack3', dependencies: [])],
        ]
      end
      let(:packwerk_package_name_mapping) do
        {
          'packs/pack0' => 'Root',
        }
      end
      let(:packwerk_package_name_callback) do
        Proc.new { |name| name.gsub('packs/', '') }
      end

      it 'returns the mermaid flowchart with the nodes and the new names' do
        expect(flowchart).to eq(
          <<~MERMAID
            ---
            title: Title
            ---
            flowchart TD
                0("Root") --> 1("pack1");
                1 --> 2("pack2");
                1 --> 3("pack3");
          MERMAID
        )
      end
    end

    context 'when there are multiple packs and some are hidden' do
      let(:packs) do
        [
          ['packs/pack0', double(name: 'packs/pack0', dependencies: ['packs/pack1'])],
          ['packs/pack1', double(name: 'packs/pack1', dependencies: ['packs/pack2', 'packs/pack3'])],
          ['packs/pack2', double(name: 'packs/pack2', dependencies: [])],
          ['packs/pack3', double(name: 'packs/pack3', dependencies: [])],
        ]
      end
      let(:packwerk_packages_hidden) do
        [
          'packs/pack3',
        ]
      end

      it 'returns the mermaid flowchart with the nodes' do
        expect(flowchart).to eq(
          <<~MERMAID
            ---
            title: Title
            ---
            flowchart TD
                0("packs/pack0") --> 1("packs/pack1");
                1 --> 2("packs/pack2");
          MERMAID
        )
      end
    end
  end
end
