#include <catch2/catch_test_macros.hpp>

#include <piper.hpp>

#include <string>

TEST_CASE("smoke: piper reports version", "[smoke]") {
    auto version = piper::getVersion();
    CHECK(version.find("1.2.0") != std::string::npos);
}
