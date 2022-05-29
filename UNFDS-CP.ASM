; fds-cp v0.4a *unpacker*  (c) DarkGrey //[DSA]
;
                model   tiny
                .code   
                .startup 
                .586 
                jumps   
start:   
;-------- Show (c)
                mov     ah, 09h
                mov     dx, offset msg
                int     21h
;------
                mov     si, 81h
                lodsb   
                cmp     al, 0dh
                je      usage_
;------
                xor     ax, ax
                mov     si, 80h
                lodsb   
                add     si, ax
                mov     [sh], al
                xchg    si, di
                mov     al, 00h
                stosb   
;---------
                mov     si, 82h
                mov     dx, si
;---------
                mov     ah, 09h
                mov     dx, offset pf
                int     021h
;---------
                mov     ah, 40h
                xor     ch, ch
                mov     cl, [sh]
                mov     bx, 1
                mov     dx, 82h
                int     021h
;--------- Open file
                mov     ah, 3dh
                mov     dx, 82h
                xor     al, al
                int     21h
                mov     [hr], ax
                jc      errs
;----- Find file size
                mov     ax, 4202h
                xor     cx, cx
                xor     dx, dx
                mov     bx, [hr]
                int     21h
                jc      errs
;----
                mov     [f_s], ax
;---- Set pointer to begin
                mov     ax, 4200h
                xor     cx, cx
                xor     dx, dx
                mov     bx, [hr]
                int     21h
                jc      errs
;------ Read from file
                mov     ah, 3fh
                mov     dx, offset buffer
                mov     cx, [f_s]
                mov     bx, [hr]
                int     21h
                jc      errs
;----- Close file
                mov     ah, 3eh
                mov     bx, [hr]
                int     21h
                jc      errs
;-----
                mov     di, offset buffer
                mov     si, di
                lodsw   
                cmp     ax, 0ca8ch
                jne     not_
;-
                mov     si, offset buffer+4dh
                lodsw   
                xchg    bx, ax
                mov     si, offset buffer+45h
                lodsw   
                xchg    cx, ax
                mov     [bc], cx
;-
                mov     di, offset buffer+52h
                mov     si, di
@@1:     
                lodsw   
                xor     ax, bx
                stosw    
                loop    @@1
;-
                mov     bp, offset buffer+225h
                mov     si, offset buffer+0ech
                lodsw   
                mov     [_1_v], ax
                mov     si, offset buffer+0fdh
                lodsw   
                mov     [_2_v], ax
;-
                mov     cx, [bc]
;-
                sub     bp, 100h
                mov     si, bp
                mov     di, si
                mov     bp, 102h
;-
@@EA:       
;-
                lodsw   
                xor     ax, [_1_v]
                mov     bx, cx
                add     bx, 001Ch
                neg     bx
                rol     bx, 03h
                xor     bx, [_2_v]
                xor     ax, bx
                sub     si, 0125h
                cmp     si, offset buffer+0223h-100h
                jnb     @@11D
                xor     ax, bp
                xchg    ax, bx
                xor     edx, edx
                lodsw   
                add     bp, 2
                dec     si
                xor     bx, ax
                dec     si
                xchg    ax, bx
@@11D:    
                add     si, 0124h
                stosw   
                inc     si
                loop    @@EA
                mov     di, offset buffer+309h
                mov     si, di
                mov     cx, 16ah
@@2:     
                lodsb   
                xor     al, 03h
                xor     al, 48h
                xor     al, 42h
                xor     al, 21h
                stosb   
                loop    @@2
;-
                mov     di, offset buffer+31dh
                mov     si, di
                mov     cx, 24h
@@3:     
                lodsb   
                xor     al, 08h
                stosb   
                loop    @@3
;-
                mov     cx, 22h
                mov     di, offset buffer+379h
                mov     si, di
@@4:                  
                lodsb    
                xor     al, 03ah
                stosb    
                loop    @@4
;-
                mov     cx, 104h
                mov     di, offset buffer+39bh
                mov     si, di
@@5:                  
                lodsb    
                xor     al, cl
                xor     al, ch
                xor     al, 37h
                stosb    
                loop    @@5
;-
                mov     si, offset buffer+049Fh
                mov     di, offset buffer+049fh
                mov     cx, [f_s]
                sub     cx, 049eh+10
                mov     [n_f_s], cx
                mov     bp, 100h
@@3d5:                  
                lodsb    
                xor     ax, 8C60h
                xor     ah, ah
                add     dx, ax
                xor     ax, bp
                stosb    
                inc     bp
                loop    @@3D5
;-
w_t:                    
                cld      
                mov     di, 82h
                xor     ax, ax
                mov     cx, 0ffffh
                repne   scasb
                mov     byte ptr [di-4], 'u'
                mov     byte ptr [di-3], 'n'
                mov     byte ptr [di-2], 'p'
;------------ Create file
                mov     ah, 3ch
                mov     dx, 82h
                xor     cx, cx
                int     21h
                jc      errs
;----- Write file , unpacked code
                mov     [hw], ax
                mov     ah, 40h
                mov     dx, offset buffer+49fh
                mov     cx, [n_f_s]
                mov     bx, [hw]
                int     21h
                jc      errs
;--- Close file
                mov     ah, 3eh
                mov     bx, [hw]
                int     21h
                jc      errs
;---
                mov     dx, offset cm
                call    write
                mov     ah, 40h
                mov     bx, 1
                mov     dx, 82h
                mov     cl, [sh]
                xor     ch, ch
                int     21h
                int     20h
;-----
write:                  
                mov     ah, 09h
                int     21h
                ret      
;-
errs:                   
                mov     dx, offset errs_
                call    write
                jmp     ext
;-
not_:                   
                mov     dx, offset nc_
                call    write
                jmp     ext
;-
usage_:                 
                mov     dx, offset usage
                call    write
;-
ext:                    
                mov     ah, 4ch
                int     21h
;-

;-
;-
msg             db      , 13, 10, 'fds-cp v0.4a *unpacker* (c) DarkGrey.', 13, 10, 13, 10, '$'
usage           db      'Usage: unfds-cp.com packed.com', 13, 10, '$'
nc_             db      , 13, 10, 'I''s not file crypted by fds-cp v0.4a', 13, 10, '$'
pf              db      'Unpacking file: $'
cm              db      , 13, 10, 'Completed !', 13, 10
                db      'Result in: $'
errs_           db      'I/O Error !', 13, 10, '$'
_1_v            dw      0
_2_v            dw      0
bc              dw      0
f_s             dw      0
n_f_s           dw      0
hr              dw      0
hw              dw      0
sh              db      0
buffer          db      ?
                end      