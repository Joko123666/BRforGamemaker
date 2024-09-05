// 메인 스텝 이벤트에서 실행
player_move();
if (keyboard_check_pressed(vk_space)) {
    destroy_object();
}
if (keyboard_check_pressed(vk_shift)) {
    player_use_special();
}
