setup() {
    bats_load_library 'bats-support'
    bats_load_library 'bats-assert'
}

@test "test assert just works" {
    assert [ 1 -gt 0 ]
}
