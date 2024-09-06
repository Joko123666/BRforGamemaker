
// 플레이어 초기화
function player_init() {
    y = room_height -BLOCK_HEIGHT*2;
    line = 2; // 플레이어가 시작하는 라인 (0~4)
    max_speed = 7;
	min_speed = 3;
	now_speed = 5;
    max_line = 3; // 총 4개의 라인
	max_fuel = 100;
	now_fuel = 100;
    gauge = 0; // 필살기 게이지
    gauge_max = 100; // 필살기 게이지 최대값
	is_moving = false;
	maxHP = 100;
	HP = maxHP;
	
}

// 플레이어 이동 처리
function player_move() {
    if (!is_moving) {
        if (keyboard_check_pressed(vk_up) && line > 0) {
            line--;
            move_target_y = y - BLOCK_HEIGHT;
            is_moving = true;
        }
        if (keyboard_check_pressed(vk_down) && line < max_line) {
            line++;
            move_target_y = y + BLOCK_HEIGHT;
            is_moving = true;
        }
    }

    // 이동 모션 처리
    if (is_moving) {
        y = lerp(y, move_target_y, 0.1); // 부드럽게 이동
        if (abs(y - move_target_y) < 1) {
            y = move_target_y;
            is_moving = false; // 이동 완료
        }
    }
}


// 필살기 사용
function player_use_special() {
    if (gauge >= gauge_max) {
        // 모든 라인의 오브젝트 파괴 로직
        destroy_all_objects();
        gauge = 0; // 게이지 초기화
    }
}

// 오브젝트 파괴
function destroy_object() {
    // 현재 라인의 오브젝트 파괴 로직
    var obj = instance_position(x, y, obj_object); // 동일 라인에 있는 오브젝트 탐색
    if (obj) {
        instance_destroy(obj);
        gauge += 10; // 필살기 게이지 증가
    }
}

// 아이템 생성 및 획득
function create_random_item() {
    var item_type = choose("speed", "power", "shield");
    var item = instance_create_layer(random(room_width), random(room_height), "Instances", obj_item);
    item.item_type = item_type;
}

// 아이템 획득 시 효과
function apply_item_effect(item) {
    switch (item.item_type) {
        case "speed":
            speed += 1; // 속도 증가
            break;
        case "power":
            power_level += 1; // 파워 증가
            break;
        case "shield":
            shield_active = true; // 실드 활성화
            break;
    }
    instance_destroy(item); // 아이템 파괴
}
