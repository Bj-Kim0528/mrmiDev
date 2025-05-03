// app/javascript/channels/chat_channel.js
import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
  const container = document.getElementById("messages")
  if (!container) return

  const conversationId = container.dataset.conversationId
  consumer.subscriptions.create(
    { channel: "ChatChannel", conversation_id: conversationId },
    {
      received(html) {
        container.insertAdjacentHTML("beforeend", html)
        container.scrollTop = container.scrollHeight
      }
    }
  )
})

