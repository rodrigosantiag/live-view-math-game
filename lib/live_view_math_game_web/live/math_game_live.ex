defmodule LiveViewMathGameWeb.MathGameLive do
  use LiveViewMathGameWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>Math Game</h1>
      <p>Your current score: <%= @score %></p>
      <p>What is <%= @left_number %> + <%= @right_number %>?</p>

      <.simple_form id="answer-from" for={@form} phx-submit="check_answer">
        <.input type="number" field={@form[:answer]} label="Answer" />
        <:actions>
          <.button>Submit</.button>
        </:actions>
      </.simple_form>

      <p><%= @message %></p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, new_question(socket, 0)}
  end

  def handle_event("check_answer", %{"answer" => answer}, socket) do
    correct_answer = socket.assigns.left_number + socket.assigns.right_number
    user_answer = String.to_integer(answer)

    if correct_answer == user_answer do
      score = socket.assigns.score + 1
      {:noreply, new_question(socket, score, "Correct!")}
    else
      {:noreply, assign(socket, message: "Incorrect!", form: to_form(%{"answer" => ""}))}
    end
  end

  defp new_question(socket, score, message \\ "") do
    left_number = random_number()
    right_number = random_number()

    socket
    |> assign(:left_number, left_number)
    |> assign(:right_number, right_number)
    |> assign(:score, score)
    |> assign(:answer, "")
    |> assign(:message, message)
    |> assign(:form, to_form(%{"answer" => ""}))
  end

  defp random_number() do
    Enum.random(1..100)
  end
end
