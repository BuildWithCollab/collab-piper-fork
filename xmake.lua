-- 🔊 Piper TTS xmake build
-- Neural text-to-speech with diverse voices

add_repositories("BuildWithCollab https://github.com/BuildWithCollab/Packages.git")

add_requires("piper-phonemize")
add_requires("spdlog")
add_requires("onnxruntime")

option("build_executable")
    set_default(true)
    set_showmenu(true)
    set_description("Build the piper CLI binary")
option_end()

----------------------------------------------------------------------
-- 📦 piper — TTS library (static)
----------------------------------------------------------------------
target("piper_lib")
    set_kind("static")
    set_languages("cxx17")

    add_files("src/cpp/piper.cpp")
    add_includedirs("src/cpp", { public = true })

    add_defines('_PIPER_VERSION="1.2.0"')

    add_packages("piper-phonemize", { public = true })
    add_packages("spdlog", { public = true })
    add_packages("onnxruntime", { public = true })

    add_headerfiles(
        "src/cpp/(piper.hpp)",
        "src/cpp/(wavfile.hpp)",
        "src/cpp/(json.hpp)",
        "src/cpp/(utf8.h)",
        "src/cpp/(utf8/*.h)"
    )
target_end()

----------------------------------------------------------------------
-- 🛠️  piper — CLI binary
----------------------------------------------------------------------
if get_config("build_executable") then
    target("piper")
        set_kind("binary")
        set_languages("cxx17")

        add_files("src/cpp/main.cpp")
        add_includedirs("src/cpp")

        add_defines('_PIPER_VERSION="1.2.0"')

        add_deps("piper_lib")
        add_packages("spdlog", "onnxruntime")

        -- Set rpath so the binary can find onnxruntime's shared library
        on_load(function (target)
            local ort = target:pkg("onnxruntime")
            if ort then
                local basedir = ort:installdir()
                if basedir then
                    target:add("rpathdirs", path.join(basedir, "lib"))
                end
            end
        end)
    target_end()
end
