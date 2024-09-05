

// oGame 초기화
function game_init()
{
    game_state = "title"; // 초기 상태는 타이틀 화면
    selected_option = 0; // 현재 선택된 옵션 (0: 게임 시작, 1: 게임 설정, 2: 게임 종료)
    options = ["게임 시작", "게임 설정", "게임 종료"]; // 타이틀 화면에서의 옵션
    max_options = 2; // 옵션 개수
	road_length = 1280;
	// 게임 상태 관련 변수
	global.is_paused = false; // 게임이 일시정지 상태인지 여부
	pause_selected_option = 0; // 일시정지 메뉴에서 선택된 옵션 (0: 계속하기, 1: 스테이지 선택)

	// 일시정지 메뉴 옵션 리스트
	pause_menu_options = ["계속하기", "스테이지 선택으로 돌아가기"];
	pause_menu_max_options = array_length(pause_menu_options) - 1;
	
	// 스테이지 정보 배열 설정
	stage_info = [
	    {name: "스테이지 1", difficulty: "쉬움", description: "초보자를 위한 쉬운 스테이지"},
	    {name: "스테이지 2", difficulty: "중간", description: "도전적인 중간 난이도의 스테이지"},
	    {name: "스테이지 3", difficulty: "어려움", description: "숙련자용 어려운 스테이지"}
	];

	// 선택된 스테이지 인덱스
	selected_stage_index = 0;

	// 애니메이션 및 입력 차단 관련 변수 설정
	input_disabled = false;   // 입력이 가능한지 여부
	animation_progress = 0;   // 애니메이션 진행도 (0 ~ 1)
	animation_duration = 60;  // 애니메이션의 프레임 수 (60프레임 = 1초)
	selected_stage_index = 0; // 현재 선택된 스테이지 인덱스
	transitioning = false;    // 애니메이션이 진행 중인지 여부

	// 화면 전환 관련 변수 설정
	transition_black_x = room_width;   // 검은색 스프라이트의 초기 위치 (오른쪽에서 시작)
	transition_black_speed = 20;       // 검은색 스프라이트가 이동하는 속도
	is_transitioning = false;          // 화면 전환이 진행 중인지 여부
	transition_phase = 0;              // 0: 덮는 중, 1: 열리는 중

	initialize_input();
}

// 게임 시작 시 입력 변수 초기화
function initialize_input() {
    global.game_input_up = false;
    global.game_input_down = false;
    global.game_input_left = false;
    global.game_input_right = false;
    global.game_input_confirm = false;
    global.game_input_cancel = false;
}

// 입력 업데이트 함수
function update_input() {
    global.game_input_up = keyboard_check_pressed(vk_up);
    global.game_input_down = keyboard_check_pressed(vk_down);
    global.game_input_left = keyboard_check_pressed(vk_left);
    global.game_input_right = keyboard_check_pressed(vk_right);
    global.game_input_confirm = keyboard_check_pressed(vk_enter);
    global.game_input_cancel = keyboard_check_pressed(vk_escape);
}


// 타이틀 화면에서의 입력 처리
function title_input() {
    if (keyboard_check_pressed(vk_up)) {
        selected_option -= 1;
        if (selected_option < 0) selected_option = max_options;
    }
    if (keyboard_check_pressed(vk_down)) {
        selected_option += 1;
        if (selected_option > max_options) selected_option = 0;
    }
    if (keyboard_check_pressed(vk_enter)) {
        switch (selected_option) {
            case 0: // 게임 시작
                game_state = "stage_select";
                room_goto(rm_stage_select);
                break;
            case 1: // 게임 설정
                game_state = "settings";
                // 설정 화면으로 이동 로직 추가
                break;
            case 2: // 게임 종료
                game_end();
                break;
        }
    }
}

// 타이틀 화면 그리기
function title_draw() 
{
	draw_set_color(c_white);
	var _x = (room_width/2);
	var _y = (room_height/4);
    draw_text(_x, _y, "타이틀 화면");
    for (var i = 0; i <= max_options; i++) {
        var option_text = options[i];
        var y_offset = room_height / 2 + i * 40;
        if (i == selected_option) {
            draw_set_color(c_yellow); // 선택된 옵션은 노란색으로 표시
        } else {
            draw_set_color(c_white);
        }
        draw_text(room_width / 2, y_offset, option_text);
    }
}

// 스테이지 선택 화면 그리기
function stage_select_draw() {
    draw_text(room_width / 2, room_height / 4, "스테이지 선택");
    draw_text(room_width / 2, room_height / 2, "스테이지 1 시작");
}
// 선택된 스테이지 정보를 화면에 표시
function draw_stage_info() {
    var stage = stage_info[selected_stage_index];
    var info_x = room_width / 2 + 100; // 화면 중앙 오른쪽에 표시할 X 좌표
    var info_y = room_height / 2; // 화면 중앙 Y 좌표

    draw_text(info_x, info_y - 40, "스테이지 이름: " + stage.name);
    draw_text(info_x, info_y, "난이도: " + stage.difficulty);
    draw_text(info_x, info_y + 40, "설명: " + stage.description);
}

// 스테이지 선택 입력 처리 함수
// 스테이지 선택 입력 처리 함수
function stage_select_input() {
    // 좌우 방향키로 스테이지 변경
    if (global.game_input_left) {
        selected_stage_index -= 1;
        if (selected_stage_index < 0) selected_stage_index = array_length(stage_info) - 1;
    }
    if (global.game_input_right) {
        selected_stage_index += 1;
        if (selected_stage_index >= array_length(stage_info)) selected_stage_index = 0;
    }

    // 엔터 키로 스테이지 선택
    if (global.game_input_confirm) {
        start_black_transition(); // 검은색 화면 전환 시작
    }
}




// oGame의 도로 스크롤 관련 변수 초기화
function road_init() {
    road_x = 0; // 도로 스크롤 시작 위치
    road_speed = 4; // 스크롤 속도
}

// 스테이지 선택 시 도로 이미지와 갯수를 설정하는 함수
function stage_setup(stage_number) {
    switch(stage_number) {
        case 1:
            road_image_index = 0; // sRoad 스프라이트의 0번째 이미지
            road_length = 3;      // 도로 3개의 이미지로 구성
            break;
        case 2:
            road_image_index = 1; // sRoad 스프라이트의 1번째 이미지
            road_length = 4;      // 도로 4개의 이미지로 구성
            break;
        case 3:
            road_image_index = 2; // sRoad 스프라이트의 2번째 이미지
            road_length = 5;      // 도로 5개의 이미지로 구성
            break;
        default:
            road_image_index = 0; // 기본값
            road_length = 3;      // 기본값
            break;
    }
}

// 도로 스크롤 처리 함수
function road_scroll() {
    road_x -= road_speed;
    if (road_x <= -640) {
        road_x = 0;
    }
}

// 도로 그리기 함수 (도로 갯수에 따라 반복해서 그리기)
function road_draw() {
    for (var i = 0; i < road_length; i++) {
        var x_position = road_x + (i * 640); // 각 도로를 이어서 그리기
        draw_sprite(sRoad, road_image_index, x_position, room_height - 64);
    }
}

// 애니메이션 시작 함수
function start_transition() {
    transitioning = true;       // 애니메이션 진행 중
    input_disabled = true;      // 입력 차단
    animation_progress = 0;     // 애니메이션 초기화
}

// 애니메이션 처리 함수
// 애니메이션 처리 함수 (업데이트)
function update_transition() {
    if (transitioning) {
        animation_progress += 1 / animation_duration;

        // 애니메이션이 완료되었을 때 처리
        if (animation_progress >= 1) {
            transitioning = false;
            input_disabled = false;
            animation_progress = 0;
            room_goto(rm_stage1); // 스테이지 룸으로 이동
			game_state = "playing"
        }
    }
}


// 애니메이션 그리기 함수
function draw_transition() {
    if (transitioning) {
        // 화면을 좌에서 우로 이동시키는 연출
        var offset_x = -room_width * animation_progress; // 애니메이션 진행도에 따른 오프셋 계산
        draw_surface_part(application_surface, 0, 0, room_width, room_height, offset_x, 0);
    }
}

// 애니메이션 종료 시 입력 차단 해제 함수
function end_transition() {
    transitioning = false;
    input_disabled = false;
    animation_progress = 0;
}

// 화면 전환 애니메이션 시작 함수
function start_black_transition() {
    is_transitioning = true;          // 화면 전환 시작
    transition_black_x = room_width;  // 검은색 스프라이트는 오른쪽 끝에서 시작
    transition_phase = 0;             // 덮기부터 시작
}

// 화면 전환 애니메이션 처리 함수
function update_black_transition() {
    if (is_transitioning) {
        if (transition_phase == 0) {
            // 검은 화면이 왼쪽으로 덮기 시작
            transition_black_x -= transition_black_speed;
            if (transition_black_x <= 0) {
                // 화면을 덮은 후, 룸 이동
                transition_black_x = 0;  // 스프라이트가 완전히 덮임
                room_goto(rm_stage1);    // 스테이지 이동
				game_state = "playing";
                transition_phase = 1;    // 열기 단계로 전환
            }
        } else if (transition_phase == 1) {
            // 화면을 열기 시작 (계속 왼쪽으로 이동)
            transition_black_x -= transition_black_speed;
            if (transition_black_x <= -room_width) {
                // 검은 화면이 완전히 사라졌을 때 전환 종료
                is_transitioning = false;
            }
        }
    }
}

// 화면 전환 그리기 함수
function draw_black_transition() {
    if (is_transitioning) {
        draw_sprite_stretched(sColor, 0, transition_black_x, 0, room_width, room_height); // 검은색 스프라이트를 화면에 그리기
    }
}


// 게임 스테이지 입력 처리 함수
function game_stage_input() {
    // ESC 키를 눌렀을 때 일시정지 메뉴 활성화
    if (global.game_input_cancel && !global.is_paused) {
        global.is_paused = true;
    }
}
// 일시정지 메뉴 입력 처리 함수
function pause_menu_input() {
    if (global.game_input_up) {
        pause_selected_option -= 1;
        if (pause_selected_option < 0) pause_selected_option = pause_menu_max_options;
    }
    if (global.game_input_down) {
        pause_selected_option += 1;
        if (pause_selected_option > pause_menu_max_options) pause_selected_option = 0;
    }

    // Enter 키로 선택된 옵션 실행
    if (global.game_input_confirm) {
        switch (pause_selected_option) {
            case 0:
                // 계속하기
                global.is_paused = false; // 일시정지 해제
                break;
            case 1:
                // 스테이지 선택으로 돌아가기
                global.is_paused = false;
                room_goto(rm_stage_select); // 스테이지 선택 룸으로 이동
                break;
        }
    }
}
// 일시정지 메뉴 그리기 함수
function draw_pause_menu() {
    draw_text(room_width / 2, room_height / 3, "일시정지");

    for (var i = 0; i <= pause_menu_max_options; i++) {
        var option_text = pause_menu_options[i];
        var y_offset = room_height / 2 + i * 40;

        if (i == pause_selected_option) {
            draw_set_color(c_yellow); // 선택된 옵션은 노란색으로 표시
        } else {
            draw_set_color(c_white);
        }
        draw_text(room_width / 2, y_offset, option_text);
    }
    draw_set_color(c_white); // 색상 초기화
}
