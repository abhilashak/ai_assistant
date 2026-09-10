require "test_helper"

class Ai::VectorSearchServiceTest < ActiveSupport::TestCase
  test "returns nearest document chunks" do
    document = Document.create!(title: "Ruby Guide", source: "test")

    document.document_chunks.create!(
      content: "Ruby blocks are passed to methods.",
      chunk_index: 0,
      embedding: Array.new(1024, 0.1)
    )

    document.document_chunks.create!(
      content: "Ruby modules allow code reuse.",
      chunk_index: 1,
      embedding: Array.new(1024, 0.2)
    )

    fake_embedding_service = Minitest::Mock.new

    fake_embedding_service.expect(
      :call,
      Array.new(1024, 0.2),
      text: "How do I reuse Ruby code?"
    )

    service = Ai::VectorSearchService.new(
      embedding_service: fake_embedding_service
    )

    results = service.call(
      query: "How do I reuse Ruby code?",
      limit: 1
    )

    assert_equal 1, results.size
    assert_equal "Ruby modules allow code reuse.", results.first.content

    fake_embedding_service.verify
  end
end
