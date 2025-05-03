import consumer from "./consumer"

consumer.subscriptions.create(
  { channel: "ConversationsPreviewChannel" },
  {
    received(data) {
      // data는 { id: "conversation_5", html: "<li>…</li>" }
      const wrapper = document.getElementById(data.id)
      if (wrapper) {
        wrapper.outerHTML = data.html
      }
    }
  }
)