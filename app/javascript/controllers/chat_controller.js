import { Controller } from "@hotwired/stimulus"

console.log("chat_controller.js loaded")

export default class extends Controller {
  connect() {
    console.log("Chat controller connected")
  }

  submit(event) {
    console.log("Chat submit triggered")

    event.preventDefault()

    const form = event.currentTarget
    const url = form.action
    const formData = new FormData(form)

    const responseElement = document.querySelector("#streaming-response")
    responseElement.textContent = ""

    const conversationId = url.match(/conversations\/(\d+)\/messages/)[1]
    const streamUrl = 
      `/conversations/${conversationId}/messages/stream?${new URLSearchParams(
          formData
        )}`

    const source = new EventSource(streamUrl)
    source.addEventListener("message", (event) => {
      const data = JSON.parse(event.data)

      responseElement.textContent += data.content
    })

    source.addEventListener("done", () => {
      source.close()

      // Reload for now so the persisted assistant message appears.
      window.location.reload()
    })

    source.onerror = () => {
      source.close()
      responseElement.textContent += "\n\n[AI stream disconnected]"
    }
  }
}