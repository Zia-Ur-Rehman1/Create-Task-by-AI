class ChatgptService
  include HTTParty
  base_uri OPENAI_BASE_URI
  CHAT_COMPLETIONS_ENDPOINT = "/chat/completions"

  def initialize
    @options = {
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{OPENAI_API_KEY}"
      }
    }
  end

  def generate(goal)
    @options[:body] = {
      model: OPENAI_API_MODEL,
      messages: [ { role: "system", content: build_prompt(goal) } ]
    }.to_json

    response = self.class.post(CHAT_COMPLETIONS_ENDPOINT, @options)
    handle_response(response)
  rescue HTTParty::Error => e
    { error: "Request failed: #{e.message}" }
  rescue JSON::ParserError => e
    { error: "Failed to parse response: #{e.message}" }
  rescue StandardError => e
    { error: "An unexpected error occurred: #{e.message}" }
  end

  private

  def build_prompt(goal)
    <<~PROMPT
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

      Goal: #{goal}

      Task List:
    PROMPT
  end

  def handle_response(response)
    if response.success?
      content = response.parsed_response.fetch("choices", [ {} ]).first.fetch("message", {}).fetch("content", "{}")
      JSON.parse(content)
    else
      { error: "API request failed with status code #{response.code}: #{response.body}" }
    end
  end
end
