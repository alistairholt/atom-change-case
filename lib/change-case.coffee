ChangeCase = require 'change-case'

Commands =
  camel: 'camelCase'
  constant: 'constantCase'
  dot: 'dotCase'
  lower: 'lowerCase'
  lowerFirst: 'lowerCaseFirst'
  param: 'paramCase'
  pascal: 'pascalCase'
  path: 'pathCase'
  sentence: 'sentenceCase'
  snake: 'snakeCase'
  switch: 'swapCase'
  swap: 'swapCase'
  title: 'titleCase'
  upper: 'upperCase'
  upperFirst: 'upperCaseFirst'
  kebab: 'paramCase'

# NOTE: New commands musst be added to the activationCommands
# in the package.json

module.exports =
  activate: (state) ->
    for command of Commands
      makeCommand(command)

makeCommand = (command) ->
  atom.commands.add 'atom-workspace', "change-case:#{command}", (event) ->
    editor = getEditorFromElement(event.target) if event?
    editor = atom.workspace.getActiveTextEditor() unless editor?

    return unless editor?

    method = Commands[command]
    converter = ChangeCase[method]

    editor.mutateSelectedText (selection) ->
      if selection.isEmpty()
        selection.selectWord()

      text = selection.getText()
      text = text.replace("\r\n", "\n") # Just in case
      lines = text.split("\n")
      newLines = []
      lines.forEach (line) ->
        newLines.push converter(line)
      newText = newLines.join("\n")

      selection.insertText newText, select: true

getEditorFromElement = (element) ->
  element.closest('atom-text-editor')?.getModel()
