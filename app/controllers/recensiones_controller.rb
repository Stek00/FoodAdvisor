class RecensionesController < ApplicationController
  before_action :set_recensione, only: %i[ show edit update destroy ]
  before_action :has_ristorante_and_utente, :only => [:new, :create, :show]

  # GET /recensiones or /recensiones.json
  def index
    @recensiones = Recensione.all
  end

  # GET /recensiones/1 or /recensiones/1.json
  def show
  end

  # GET /recensiones/new
  def new
    @recensione = Recensione.new
  end

  # GET /recensiones/1/edit
  def edit
  end

  # POST /recensiones or /recensiones.json
  def create
    @recensione = Recensione.new(recensione_params)

    @rist=Ristorante.find_by(id:params[:ristorante_id])
    @ut=Utente.find_by(id: session[:user_id])

    @recensione.ristorante_id = params[:ristorante_id]
    @recensione.utente_id= session[:user_id]

    #@current_user.recensione << @recensione
    @ut.recensiones << @recensione
    @rist.recensiones << @recensione

    respond_to do |format|
      if @recensione.save
        format.html { redirect_to ristorante_recensione_path(@ristorante,@recensione), notice: "Recensione was successfully created." }
        format.json { render :show, status: :created, location: @recensione }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recensione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recensiones/1 or /recensiones/1.json
  def update
    respond_to do |format|
      if @recensione.update(recensione_params)
        format.html { redirect_to recensione_url(@recensione), notice: "Recensione was successfully updated." }
        format.json { render :show, status: :ok, location: @recensione }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recensione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recensiones/1 or /recensiones/1.json
  def destroy
    @recensione.destroy

    respond_to do |format|
      format.html { redirect_to recensiones_url, notice: "Recensione was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recensione
      @recensione = Recensione.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recensione_params
      params.require(:recensione).permit(:titolo, :commento, :datavisita, :datarecensione, :valutazione, :prezzo, :foto1, :foto2, :foto3, :foto4, :foto5, :foto6, :utente_id, :ristorante_id, )
    end
  
  protected
  def has_ristorante_and_utente
    #unless @current_user
      #flash[:warning] = 'You must be logged in to create a review.'
      #redirect_to movies_path
    #end
    unless (@ristorante = Ristorante.where(:id => params[:ristorante_id]).first)
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to ristorante_path
    end
  end

end
