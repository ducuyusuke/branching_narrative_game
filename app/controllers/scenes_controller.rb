class ScenesController < ApplicationController
  before_action :set_scene, only: %i[show edit update destroy]
  def show
    @scene = Scene.find(params[:id])
    # Lógica de posição dos NPCS
    dialogues = @scene.story.gsub("{pc_name}", current_user.narratives.first.pc_name)
    @scene.npcs.each_with_index do |npc, index|
      dialogues.gsub!("{npc#{index+1}}", npc.name)
    end
    @story = dialogues.split("{newline}")
  end

  def edit
    # authorize @scene
  end

  def new
    @scene = Scene.new
    @tale = Tale.find(params[:tale_id])
    @scene.tale = @tale
    # authorize @scene
  end

  def create
    @scene = Scene.new(scene_params)
    @tale = Tale.find(params[:tale_id])
    @scene.tale = @tale
    # authorize @scene
    if @scene.save!
      redirect_to scene_path(@scene)
    else
      redirect_to new_tale_scene_path(params[:tale_id])
    end
  end

  def update
    # authorize @scene
    if @scene.update(scene_params)
      redirect_to @scene, notice: "Your scene has been updated"
    else
      redirect_to edit_scene_path(@scene)
    end
  end

  def destroy
    # authorize @scene
    @scene.destroy
    redirect_to scenes_url, notice: "Your scene has been deleted"
  end

  private

  def scene_params
    params.require(:scene).permit(:story, :npc_position1, :npc_position2, :npc_position3)
  end

  def set_scene
    @scene = Scene.find(params[:id])
  end
end



# @story = @scene.story.gsub("{pc_name}", narrative.pc_name).gsub("{npc1}", @scene.npcs[0].name).gsub("{npc2}", @scene.npcs[1].name).gsub("{npc3}", @scene.npcs[2].name).split("{newline}")
