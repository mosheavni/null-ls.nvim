local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

return h.make_builtin({
    name = "npm_groovy_lint",
    meta = {
        url = "https://github.com/nvuillam/npm-groovy-lint",
        description = "Lint, format and auto-fix Groovy, Jenkinsfile, and Gradle files.",
    },
    method = DIAGNOSTICS,
    filetypes = { "groovy", "java", "Jenkinsfile" },
    generator_opts = {
        command = "npm-groovy-lint",
        format = "json",
        to_stdin = true,
        ignore_stderr = false,
        args = { "--output", "json", "--parse", "-" },
        on_output = function(params)
            local messages = params.output.files["0"].errors
            local diagnostics = {}
            for _, message in ipairs(messages) do
                table.insert(diagnostics, {
                    row = message.line,
                    end_row = message.range["end"].line,
                    col = message.range.start.character,
                    end_col = message.range["end"].character,
                    code = message.rule,
                    severity = message.level,
                    message = message.msg,
                })
            end
            return diagnostics
        end,
    },
    factory = h.generator_factory,
})
