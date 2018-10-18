.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE debug.h
INCLUDE sqrt.h

.STACK  4096

BUFFER_SIZE EQU s

.DATA

eyepoint_x WORD ? 
eyepoint_y WORD ? 
eyepoint_z WORD ?

lookatpoint_x WORD ? 
lookatpoint_y WORD ? 
lookatpoint_z WORD ? 

updirection_x WORD ? 
updirection_y WORD ? 
updirection_z WORD ? 

dot_product_of_n_and_n WORD ?
dot_product_of_n_and_updirection WORD ?

n1 WORD ?
n2 WORD ?
n3 WORD ?

v1 WORD ?
v2 WORD ?
v3 WORD ?

u1 WORD ?
u2 WORD ?
u3 WORD ?

new_n1 WORD ?
new_n2 WORD ?
new_n3 WORD ?

new_v_up1 WORD ?
new_v_up2 WORD ?
new_v_up3 WORD ?

crossproduct_v_and_n1 WORD ?
crossproduct_v_and_n2 WORD ?
crossproduct_v_and_n3 WORD ?

numerator_x WORD ?
numerator_y WORD ?
numerator_z WORD ?
denominator WORD 3 DUP(?)
dot_product WORD ?


prompt_eyepoint_x BYTE "Enter the x-coordinate of the camera eyepoint:    " , 0 
prompt_eyepoint_y BYTE "Enter the y-coordinate of the camera eyepoint:    " , 0
prompt_eyepoint_z BYTE "Enter the z-coordinate of the camera eyepoint:    " , 0

prompt_lookatpoint_x BYTE "Enter the x-coordinate of the camera look at point:    " , 0 
prompt_lookatpoint_y BYTE "Enter the y-coordinate of the camera look at point:    " , 0
prompt_lookatpoint_z BYTE "Enter the z-coordinate of the camera look at point:    " , 0

prompt_updirection_x BYTE "Enter the x-coordinate of the camera up direction:    " , 0 
prompt_updirection_y BYTE "Enter the y-coordinate of the camera up direction:    " , 0
prompt_updirection_z BYTE "Enter the z-coordinate of the camera up direction:    " , 0

prompt_n BYTE "n:", 0
prompt_v BYTE "v:", 0
prompt_u BYTE "u:", 0

string     BYTE 40 DUP(?), CR, LF, 0
final_string     BYTE 40 DUP(?), CR, LF, 0
new_line    BYTE     CR, LF, 0

print MACRO x, y, z
    
    mov  string, '('
    itoa string + 1, x
    mov  string + 7, ','
    itoa string + 8, y
    mov  string + 14, ','
    itoa string + 15, z
    mov  string + 21, ')' 
    output  string
    output  new_line
    output  new_line
    ENDM

calculate_dot_product MACRO a_x, a_y, a_z, b_x, b_y, b_z, memory_location
  
    mov ax , a_x
    imul b_x
    add memory_location, ax
    ;outputW dot_product
    ;output  new_line

    mov ax , a_y
    imul b_y
    add  memory_location, ax
    ;outputW dot_product
    ;output  new_line

    mov ax , a_z
    imul b_z
    add  memory_location, ax
    ;outputW dot_product
    ;output  new_line
    ENDM


print_final_cordinate MACRO x, y, z
    
    mov  dot_product , 0
    calculate_dot_product x, y, z, x, y, z, dot_product

    ;outputW dot_product

    mov ax , dot_product
    sqrt ax
    mov denominator , ax

    ;outputW denominator

    output  new_line   
    itoa final_string + 5, denominator
    mov  final_string, '('
    itoa final_string + 1, x
    mov  final_string + 7, '/'
    mov  final_string + 11, ','

    itoa final_string + 16, denominator
    itoa final_string + 12, y
    mov  final_string + 18, '/'
    mov  final_string + 22, ','

    itoa final_string + 27, denominator
    itoa final_string + 23, z
    mov  final_string + 29, '/'
    mov  final_string + 33, ')' 

    output  final_string
    output  new_line
    ENDM

.CODE
_start:
        ;EYEPOINT
        ;x-coordinate_eyepoint
        inputW prompt_eyepoint_x, eyepoint_x ; get input, convert the ASCII to a WORD, place result in ax (ah has no meaningful data)
        outputW eyepoint_x
        ;y-coordinate_eyepoint
        inputW prompt_eyepoint_y, eyepoint_y
        outputW eyepoint_y    
        ;z-coordinate_eyepoint
        inputW prompt_eyepoint_z, eyepoint_z
        outputW eyepoint_z

        ;print eyepoint cordinates
        print eyepoint_x, eyepoint_y, eyepoint_z

        ;LOOKatPOINT
        ;x-coordinate_lookatpoint
        inputW prompt_lookatpoint_x, lookatpoint_x
        outputW lookatpoint_x
        ;y-coordinate_lookatpoint
        inputW prompt_lookatpoint_y, lookatpoint_y
        outputW lookatpoint_y
        ;z-coordinate_lookatpoint
        inputW prompt_lookatpoint_z, lookatpoint_z
        outputW lookatpoint_z 
        ;print lookatpoint cordinates
        print lookatpoint_x, lookatpoint_y, lookatpoint_z


        ;UPDIRECTION
        ;x-coordinate_updirection
        inputW prompt_updirection_x, updirection_x
        outputW updirection_x
        ;y-coordinate_lookatpoint
        inputW prompt_updirection_y, updirection_y
        outputW updirection_y
        ;z-coordinate_lookatpoint
        inputW prompt_updirection_z, updirection_z
        outputW updirection_z 
        ;print updirection cordinates
        print updirection_x, updirection_y, updirection_z
        

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;calculation part
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ;n
        ;Subtract the at point from the eye point (E - A) coordinate 
        mov ax , eyepoint_x
        sub ax , lookatpoint_x
        mov n1 , ax
        ;outputW n1

        mov ax , eyepoint_y
        sub ax , lookatpoint_y
        mov n2 , ax
        ;outputW n2    

        mov ax , eyepoint_z
        sub ax , lookatpoint_z
        mov n3 , ax
        ;outputW n3 

        

        ;outputW dot_product_of_n_and_n

        ;v
        ;v = -(v_up.n)n + (n.n)v_up
        calculate_dot_product n1, n2, n3, updirection_x, updirection_y, updirection_z, dot_product_of_n_and_updirection
        calculate_dot_product n1, n2, n3, n1, n2, n3, dot_product_of_n_and_n
        ;mov ax , -1
        ;imul dot_product_of_n_and_updirection
        neg dot_product_of_n_and_updirection
        ;mov dot_product_of_n_and_updirection , ax

        ;outputW dot_product_of_n_and_updirection

        mov ax , n1
        imul dot_product_of_n_and_updirection
        mov new_n1 , ax

        mov ax , n2
        imul dot_product_of_n_and_updirection
        mov new_n2 , ax

        mov ax , n3
        imul dot_product_of_n_and_updirection
        mov new_n3 , ax

        mov ax , updirection_x
        imul dot_product_of_n_and_n
        mov new_v_up1 , ax

        mov ax , updirection_y
        imul dot_product_of_n_and_n
        mov new_v_up2 , ax

        mov ax , updirection_z
        imul dot_product_of_n_and_n
        mov new_v_up3 , ax

        mov ax , new_n1
        add ax , new_v_up1
        mov v1 , ax

        mov ax , new_n2
        add ax , new_v_up2
        mov v2 , ax

        mov ax , new_n3
        add ax , new_v_up3
        mov v3 , ax

        ;u
        ;a x b (a cross b) = 
        ;a_y*b_z - a_z*b_y (the first component of a x b)
        ;a_z*b_x - a_x*b_z (the second component of a x b)
        ;a_x*b_y - a_y*b_x (the third component of a x b)

        ;v x n
        ;v x n (v cross n) = 
        ;v2*n3 - v3*n2 (the first component of a x b)
        ;v3*n1 - v1*n3 (the second component of a x b)
        ;v1*n2 - v2*n1 (the third component of a x b)

        mov ax , v2
        imul n3
        mov u1 , ax
        mov ax , v3
        imul n2
        sub u1 , ax

        mov ax , v3
        imul n1
        mov u2 , ax
        mov ax , v1
        imul n3
        sub u2 , ax

        mov ax , v1
        imul n2
        mov u3 , ax
        mov ax , v2
        imul n1
        sub u3 , ax

        output prompt_u
        print_final_cordinate u1, u2, u3

        output prompt_v
        print_final_cordinate v1, v2, v3

        output prompt_n
        print_final_cordinate n1, n2, n3
    
        INVOKE  ExitProcess, 0

PUBLIC _start
END