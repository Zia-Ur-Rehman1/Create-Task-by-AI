require 'rails_helper'

RSpec.describe ChatgptService, type: :service do
  let(:goal) { "Complete the project" }
  let(:chatgpt_service) { described_class.new }
  let(:response_body) do
    {
      choices: [
        {
          message: {
            content: '[ "Step 1: Define the project scope", "Step 2: Create a project plan" ]'
          }
        }
      ]
    }.to_json
  end
  let(:parsed_response) { JSON.parse(response_body) }

  describe '#generate' do
    context 'when the request is successful' do
      before do
        stub_request(:post, "#{OPENAI_BASE_URI}#{ChatgptService::CHAT_COMPLETIONS_ENDPOINT}")
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns the parsed response' do
        result = chatgpt_service.generate(goal)
        expect(result).to eq([ "Step 1: Define the project scope", "Step 2: Create a project plan" ])
      end
    end

    context 'when the request fails with an HTTParty error' do
      before do
        allow(ChatgptService).to receive(:post).and_raise(HTTParty::Error, "Request failed")
      end

      it 'returns an error message' do
        result = chatgpt_service.generate(goal)
        expect(result).to eq({ error: "Request failed: Request failed" })
      end
    end

    context 'when the response is not valid JSON' do
      before do
        stub_request(:post, "#{OPENAI_BASE_URI}#{ChatgptService::CHAT_COMPLETIONS_ENDPOINT}")
          .to_return(status: 200, body: "invalid json", headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a JSON parse error message' do
        result = chatgpt_service.generate(goal)
        expect(result).to eq({ error: "Failed to parse response: unexpected character: 'invalid json'" })
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(ChatgptService).to receive(:post).and_raise(StandardError, "Unexpected error")
      end

      it 'returns an unexpected error message' do
        result = chatgpt_service.generate(goal)
        expect(result).to eq({ error: "An unexpected error occurred: Unexpected error" })
      end
    end
  end

  describe '#build_prompt' do
    it 'returns the correct prompt' do
      prompt = chatgpt_service.send(:build_prompt, goal)
      expected_prompt = <<~PROMPT
        You are a helpful AI assistant that generates a task list based on a given goal.
        The task list should be clear, concise, and actionable, breaking down the goal into steps with sub-tasks where appropriate.
        Make sure to follow this format and provide all the steps in a correct JSON array format with each step as a string:

        Here is the example format for a task list:
        [
          "Step 1: [Action description]",
          "Step 2: [Action description]",
          "Step 3: [Action description]",
          "..."
        ]

        Ensure the steps are logical, easy to follow, and include any important tips or resources if necessary.
        Please make sure the task list is always returned in valid JSON format as shown, with no failures in structure or content.

        Goal: Complete the project

        Task List:
      PROMPT
      expect(prompt).to eq(expected_prompt)
    end
  end

  describe '#handle_response' do
    context 'when the response is successful' do
      let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: parsed_response) }

      it 'returns the parsed content' do
        result = chatgpt_service.send(:handle_response, response)
        expect(result).to eq([ "Step 1: Define the project scope", "Step 2: Create a project plan" ])
      end
    end

    context 'when the response is not successful' do
      let(:response) { instance_double(HTTParty::Response, success?: false, code: 500, body: "Internal Server Error") }

      it 'returns an error message' do
        result = chatgpt_service.send(:handle_response, response)
        expect(result).to eq({ error: "API request failed with status code 500: Internal Server Error" })
      end
    end
  end
end
