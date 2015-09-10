require 'atom'

compactCss = ->
  editor = atom.workspace.getActiveTextEditor()

  selectedText = editor.getSelectedText()
  text = selectedText || editor.getText()

  chars = text.split ''
  depth = 0
  seqWhitespace = 0
  for ch, i in chars
    if ch == '{' then depth++
    else if ch == '}' then depth--
    else if depth > 0
      if /\s/.test ch
        if ch == '\n' || ch == '\r'
          chars[i] = ' '
        if seqWhitespace > 0
          chars[i] = ''
        seqWhitespace++
      else
        seqWhitespace = 0
    else
      seqWhitespace = 0

  compactedText = chars.join('')
  if selectedText
    editor.setTextInBufferRange editor.getSelectedBufferRange(), compactedText
  else
    editor.setText compactedText

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', 'compact', compactCss
