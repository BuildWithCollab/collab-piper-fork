-- 🔊 Piper TTS xmake build
-- Neural text-to-speech with diverse voices

-- Pull in piper-phonemize (which transitively brings espeak-ng)
includes("/Users/mrowr/Code/rhasspy/piper-phonemize/xmake.lua")

-- Third-party packages from xmake repo
add_requires("spdlog")

----------------------------------------------------------------------
-- 📦 piper — TTS library (static)
----------------------------------------------------------------------
target("piper_lib")
    set_kind("static")
    set_languages("cxx17")

    add_files("src/cpp/piper.cpp")
    add_includedirs("src/cpp", { public = true })

    add_defines('_PIPER_VERSION="1.2.0"')

    add_deps("piper_phonemize")
    add_packages("spdlog", "onnxruntime")
target_end()

----------------------------------------------------------------------
-- 🛠️  piper — CLI binary
----------------------------------------------------------------------
target("piper")
    set_kind("binary")
    set_languages("cxx17")

    add_files("src/cpp/main.cpp")
    add_includedirs("src/cpp")

    add_defines('_PIPER_VERSION="1.2.0"')

    add_deps("piper_lib")
    add_packages("spdlog", "onnxruntime")

    -- Set rpath so the binary can find onnxruntime's shared library at runtime
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
